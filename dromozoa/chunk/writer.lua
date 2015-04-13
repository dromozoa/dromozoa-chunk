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

return function (handle)
  local self = {
    _h = handle;
  }

  function self:write(s)
    self._h:write(s)
  end

  function self:write_byte(v)
    self:write(string.char(v))
  end

  function self:write_boolean(v)
    if v then
      self:write_byte(1)
    else
      self:write_byte(0)
    end
  end

  function self:write_integer_impl(sepcifier, size, v)
    self:write(integer.encode(self._header.endian, specifier, size, v))
  end

  function self:write_int(v)
    self:write_integer_impl("i", self._header.sizeof_int, v)
  end

  function self:write_size_t(v)
    self:write_integer_impl("I", self._header.sizeof_size_t, v)
  end

  function self:write_instruction(v)
    self:write_integer_impl("I", self._header.sizeof_instruction, v)
  end

  function self:write_number(v)
    local H = self._header
    local size = H.sizeof_number
    if H.number == "ieee754" then
      self:write(ieee754.encode(H.endian, size, v))
    else
      self:write_integer_impl("i", size, v)
    end
  end

  function self:write_string_5_1(v)
    if v then
      self:write_size_t(#v + 1)
      self:write(v)
      self:write_byte(0)
    else
      self:write_size_t(0)
    end
  end

  function self:write_string_5_2(v)
    self:write_string_5_1(v)
  end

  function self:write_string_5_3(v)
    if v then
      local n = #v
      if n < 254 then
        self:write_byte(n + 1)
      else
        self:write_byte(255)
        self:write_size_t(n + 1)
      end
      self:write(v)
    else
      self:write_byte(0)
    end
  end

  function self:write_string(v)
    self["write_string" .. self._version_suffix](self, v)
  end

  function self:write_header_data(H)
    self:write("\25\147\r\n\26\n")
  end

  function self:write_header_5_1(H)
    self.write_boolean(H.endian == "<")
    self:write_byte(H.sizeof_int)
    self:write_byte(H.sizeof_size_t)
    self:write_byte(H.sizeof_instruction)
    self:write_byte(H.sizeof_number)
    self.write_boolean(H.number == "integer")
  end

  function self:write_header_5_2(H)
    self:write_header_5_1(H)
    self:write_header_data(H)
  end

  function self:write_header_5_3(H)
    self:write_header_data(H)
    self:write_byte(H.sizeof_int)
    self:write_byte(H.sizeof_size_t)
    self:write_byte(H.sizeof_instruction)
    self:write_byte(H.sizeof_integer)
    self:write_byte(H.sizeof_number)
    self:write_integer(0x5678)
    self:write_number(370.5)
  end

  function self:write_header(H)
    self._header = H
    self:write("\27Lua")
    self:write_byte(H.major_version * 16 + H.minor_version)
    self._version_suffix = string.format("_%d_%d", H.major_version, H.minor_version)
    self.write_byte(0)
    self["write_header" .. self._version_suffix](self, H)
  end

  function self:write_code(F)
    local code = F.code
    local n = #code
    self:write_int(n)
    for i = 1, n do
      self:write_instruction(code[i])
    end
  end

  function self:write_constant_5_1(t, v)
    if t == "boolean" then
      self:write_byte(1) -- LUA_TBOOLEAN
      self.write_boolean(v)
    elseif t == "number" then
      self:write_byte(3) -- LUA_TNUMBER
      self:write_number(v)
    elseif t == "string" then
      self:write_byte(4) -- LUA_TSTRING
      self:write_string(v)
    else
      self:write_byte(0) -- LUA_TNIL
    end
  end

  function self:write_constant_5_2(t, v)
    self:write_constant_5_1(t, v)
  end

  function self:write_constant_5_3(t, v)
    if t == "boolean" then
      self:write_byte(1) -- LUA_TBOOLEAN
      self.write_boolean(v)
    elseif t == "number" then
      if v % 1 == 0 then
        self:write_byte(19) -- LUA_TNUMINT
        self:write_integer(v)
      else
        self:write_byte(4) -- LUA_TNUMFLT
        self:write_number(v)
      end
    elseif t == "string" then
      if #v < 254 then
        self:write_byte(4) -- LUA_TSHRSTR
      else
        self:write_byte(20) -- LUA_TLNGSTR
      end
      self:write_string(v)
    else
      self:write_byte(0) -- LUA_TNIL
    end
  end

  function self:write_constants(F)
    local constants = F.constants
    local n = #constants
    self:write_int(n)
    for i = 1, n do
      local v = constants[i]
      self["write_constant" .. self._version_suffix](self, type(v), v)
    end
  end

  function self:write_upvalues(F)
    local upvalues = F.upvalues
    local n = #upvalues
    self:write_int(n)
    for i = 1, n do
      local upvalue = upvalues[i]
      self:write_boolean(upvalue.in_stack)
      self:write_byte(upvalue.idx)
    end
  end

  function self:write_protos(F)
    local protos = F.protos
    local n = #protos
    self:write_int(n)
    for i = 1, n do
      self:write_function(protos[i])
    end
  end

  function self:write_debug_line_info(F)
    local line_info = F.line_info
    local n = line_info
    self:write_int(n)
    for i = 1, n do
      self:write_int(line_info[i])
    end
  end

  function self:write_debug_loc_vars(F)
    local loc_vars = F.loc_vars
    local n = #loc_vars
    self:write_int(n)
    for i = 1, n do
      local loc_var = loc_vars[i]
      self:write_byte(loc_var.varname)
      self:write_byte(loc_var.start_pc)
      self:write_byte(loc_var.end_pc)
    end
  end

  function self:write_debug_upvalues(F)
    local upvalues = F.upvalues
    local n = #upvalues
    self:write_int(n)
    for i = 1, self:read_int() do
      self:write_string(upvalues[i].name)
    end
  end

  function self:write_debug(F)
    self:write_debug_line_info(F)
    self:write_debug_loc_vars(F)
    self:write_debug_upvalues(F)
  end

  function self:write_function_5_1(F)
    self:write_string(F.source)
    self:write_int(F.line_defined)
    self:write_int(F.last_line_defined)
    self:write_byte(#F.upvalues)
    self:write_byte(F.num_params)
    self:write_boolean(F.is_var_arg)
    self:write_byte(F.max_stack_size)
    self:write_code(F)
    self:write_constants(F)
    self:write_protos(F)
    self:write_debug(F)
  end

  function self:write_function_5_2(F)
    self:write_int(F.line_defined)
    self:write_int(F.last_line_defined)
    self:write_byte(F.num_params)
    self:write_boolean(F.is_var_arg)
    self:write_byte(F.max_stack_size)
    self:write_code(F)
    self:write_constants(F)
    self:write_protos(F)
    self:write_upvalues(F)
    self:write_string(F.source)
    self:write_debug(F)
  end

  function self:write_function_5_3(F)
    self:write_string(F.source)
    self:write_int(F.line_defined)
    self:write_int(F.last_line_defined)
    self:write_byte(F.num_params)
    self:write_boolean(F.is_var_arg)
    self:write_byte(F.max_stack_size)
    self:write_code(F)
    self:write_constants(F)
    self:write_upvalues(F)
    self:write_protos(F)
    self:write_debug(F)
  end

  function self:write_function(F)
    self["write_function" .. self._version_suffix](self, F)
  end

  function self:write_chunk_5_1(C)
    self:write_function(C.func)
  end

  function self:write_chunk_5_2(C)
    self:write_chunk_5_1(C)
  end

  function self:write_chunk_5_3(C)
    local F = C.func
    self:write_byte(F.upvalues)
    self:write_function(F)
  end

  function self:write_chunk(C)
    self:write_header(C.header)
    self["write_chunk" .. self._version_suffix](self, C)
  end
end
