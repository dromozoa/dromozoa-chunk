-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-chunk.
--
-- dromozoa-chunk is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-chunk is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-chunk.  If not, see <http://www.gnu.org/licenses/>.

local ieee754 = require "dromozoa.chunk.ieee754"
local integer = require "dromozoa.chunk.integer"

return function (handle)
  local self = {
    _h = handle;
    _i = 1;
  }

  function self:raise(message)
    if message then
      error(message .. " at position " .. self._i)
    else
      error("read error at position " .. self._i)
    end
  end

  function self:read(n)
    local v = self._h:read(n)
    if v then
      self._i = self._i + n
      return v
    end
  end

  function self:read_byte()
    local v = self:read(1)
    if v then
      return v:byte()
    end
  end

  function self:read_integer_impl(specifier, size)
    return integer.decode(self._header.endian, specifier, size, self:read(size))
  end

  function self:read_int()
    return self:read_integer_impl("i", self._header.sizeof_int)
  end

  function self:read_size_t()
    return self:read_integer_impl("I", self._header.sizeof_size_t)
  end

  function self:read_instruction()
    return self:read_integer_impl("I", self._header.sizeof_instruction)
  end

  function self:read_integer()
    return self:read_integer_impl("i", self._header.sizeof_integer)
  end

  function self:read_number()
    local H = self._header
    local size = H.sizeof_number
    if H.number == "ieee754" then
      return ieee754.decode(H.endian, size, self:read(size))
    else
      return self:read_integer_impl("i", size)
    end
  end

  function self:read_string_5_1()
    local n = self:read_size_t()
    if n ~= 0 then
      local v = self:read(n - 1)
      if self:read_byte() ~= 0 then
        self:raise()
      end
      return v
    end
  end

  function self:read_string_5_2()
    return self:read_string_5_1()
  end

  function self:read_string_5_3()
    local n = self:read_byte()
    if n == 255 then
      n = self:read_size_t()
    end
    if n ~= 0 then
      return self:read(n - 1)
    end
  end

  function self:read_string()
    return self["read_string" .. self._version_suffix](self)
  end

  function self:read_header_data(H)
    local DATA = "\25\147\r\n\26\n"
    if self:read(#DATA) ~= DATA then
      self:raise "invalid data"
    end
  end

  function self:read_header_5_1(H)
    if self:read_byte() ~= 0 then
      H.endian = "<"
    else
      H.endian = ">"
    end
    H.sizeof_int = self:read_byte()
    H.sizeof_size_t = self:read_byte()
    H.sizeof_instruction = self:read_byte()
    H.sizeof_number = self:read_byte()
    if self:read_byte() ~= 0 then
      H.number = "integer"
    else
      H.number = "ieee754"
    end
  end

  function self:read_header_5_2(H)
    self:read_header_5_1(H)
    self:read_header_data(H)
  end

  function self:read_header_5_3(H)
    self:read_header_data(H)
    H.sizeof_int = self:read_byte()
    H.sizeof_size_t = self:read_byte()
    H.sizeof_instruction = self:read_byte()
    H.sizeof_integer = self:read_byte()
    H.sizeof_number = self:read_byte()

    local magic_integer = self:read(H.sizeof_integer)
    if magic_integer:byte(1) ~= 0 then
      H.endian = "<"
    else
      H.endian = ">"
    end
    if integer.decode(H.endian, "i", H.sizeof_integer, magic_integer) ~= 0x5678 then
      self:raise "invalid magic integer"
    end

    local magic_number = self:read(H.sizeof_number)
    if ieee754.decode(H.endian, H.sizeof_number, magic_number) == 370.5 then
      H.number = "ieee754"
    elseif integer.decode(H.endian, "i", H.sizeof_number, magic_number) == 370 then
      H.number = "integer"
    end
  end

  function self:read_header()
    local H = {}
    self._header = H

    local SIGNATURE = "\27Lua"
    if self:read(#SIGNATURE) ~= SIGNATURE then
      self:raise "invalid signature"
    end

    local version = self:read_byte()
    if version < 81 or 84 < version then
      self:raise "unsupported version"
    end
    H.minor_version = version % 16
    H.major_version = (version - H.minor_version) / 16
    self._version_suffix = string.format("_%d_%d", H.major_version, H.minor_version)

    if self:read_byte() ~= 0 then
      self:raise "unsupported format"
    end

    self["read_header" .. self._version_suffix](self, H)
    return H
  end

  function self:read_code(F)
    local code = {}
    F.code = code
    for i = 1, self:read_int() do
      code[i] = self:read_instruction()
    end
  end

  function self:read_constants(F)
    local constants = {}
    F.constants = constants
    for i = 1, self:read_int() do
      local t = self:read_byte()
      local v
      if t == 1 then -- LUA_TBOOLEAN
        v = self:read_byte() ~= 0
      elseif t == 3 then -- LUA_TNUMBER (LUA_TNUMFLT)
        v = self:read_number()
      elseif t == 19 then -- LUA_TNUMINT
        v = self:read_integer()
      elseif t == 4 or t == 20 then -- LUA_TSTRING (LUA_TSHRSTR), LUA_TLNGSTR
        v = self:read_string()
      end
      constants[i] = v
    end
  end

  function self:read_upvalues(F)
    local upvalues = {}
    F.upvalues = upvalues
    for i = 1, self:read_int() do
      local upvalue = {}
      upvalues[i] = upvalue
      upvalue.in_stack = self:read_byte()
      upvalue.idx = self:read_byte()
    end
  end

  function self:read_protos(F)
    local protos = {}
    F.protos = protos
    for i = 1, self:read_int() do
      protos[i] = self:read_function()
    end
  end

  function self:read_debug_line_info(F)
    local line_info = {}
    F.line_info = line_info
    for i = 1, self:read_int() do
      line_info[i] = self:read_int()
    end
  end

  function self:read_debug_loc_vars(F)
    local loc_vars = {}
    F.loc_vars = {}
    for i = 1, self:read_int() do
      local loc_var = {}
      loc_vars[i] = loc_var
      loc_var.varname = self:read_string()
      loc_var.startpc = self:read_int()
      loc_var.endpc = self:read_int()
    end
  end

  function self:read_debug_upvalues(F)
    local upvalues = F.upvalues
    for i = 1, self:read_int() do
      upvalues[i].name = self:read_string()
    end
  end

  function self:read_debug(F)
    self:read_debug_line_info(F)
    self:read_debug_loc_vars(F)
    self:read_debug_upvalues(F)
  end

  function self:read_function_5_1(F)
    F.source = self:read_string()
    F.line_defined = self:read_int()
    F.last_line_defined = self:read_int()
    local upvalues = {}
    F.upvalues = upvalues
    for i = 1, self:read_byte() do
      upvalues[i] = {}
    end
    F.num_params = self:read_byte()
    F.is_vararg = self:read_byte() ~= 0
    F.max_stack_size = self:read_byte()
    self:read_code(F)
    self:read_constants(F)
    self:read_protos(F)
    self:read_debug(F)
  end

  function self:read_function_5_2(F)
    F.line_defined = self:read_int()
    F.last_line_defined = self:read_int()
    F.num_params = self:read_byte()
    F.is_vararg = self:read_byte() ~= 0
    F.max_stack_size = self:read_byte()
    self:read_code(F)
    self:read_constants(F)
    self:read_protos(F)
    self:read_upvalues(F)
    F.source = self:read_string()
    self:read_debug(F)
  end

  function self:read_function_5_3(F)
    F.source = self:read_string()
    F.line_defined = self:read_int()
    F.last_line_defined = self:read_int()
    F.num_params = self:read_byte()
    F.is_vararg = self:read_byte() ~= 0
    F.max_stack_size = self:read_byte()
    self:read_code(F)
    self:read_constants(F)
    self:read_upvalues(F)
    self:read_protos(F)
    self:read_debug(F)
  end

  function self:read_function()
    local F = {}
    self["read_function" .. self._version_suffix](self, F)
    return F
  end

  function self:read_chunk_5_1(C)
    C.func = self:read_function()
  end

  function self:read_chunk_5_2(C)
    C.func = self:read_function()
  end

  function self:read_chunk_5_3(C)
    local size_upvalues = self:read_byte()
    C.func = self:read_function()
    if size_upvalues ~= #C.func.upvalues then
      self:raise()
    end
  end

  function self:read_chunk()
    local C = {}
    C.header = self:read_header()
    self["read_chunk" .. self._version_suffix](self, C)
    return C
  end

  return self
end
