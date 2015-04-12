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

local SIGNATURE = "\27Lua"
local DATA = "\25\147\r\n\26\n"

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

  function self:read_header_5_1(header)
    if self:read_byte() ~= 0 then
      header.endian = "<"
    else
      header.endian = ">"
    end
    header.sizeof_int = self:read_byte()
    header.sizeof_size_t = self:read_byte()
    header.sizeof_instruction = self:read_byte()
    header.sizeof_number = self:read_byte()
    if self:read_byte() ~= 0 then
      header.number = "integer"
    else
      header.number = "ieee754"
    end
  end

  function self:read_header_5_2(header)
    self:read_header_5_1(header)
    if self:read(#DATA) ~= DATA then
      self:raise "invalid data"
    end
  end

  function self:read_header_5_3(header)
    if self:read(#DATA) ~= DATA then
      self:raise "invalid data"
    end
    header.sizeof_int = self:read_byte()
    header.sizeof_size_t = self:read_byte()
    header.sizeof_instruction = self:read_byte()
    header.sizeof_integer = self:read_byte()
    header.sizeof_number = self:read_byte()

    local magic_integer = self:read(header.sizeof_integer)
    if magic_integer:byte(1) ~= 0 then
      header.endian = "<"
    else
      header.endian = ">"
    end
    if integer.decode(header.endian, "i", header.sizeof_integer, magic_integer) ~= 0x5678 then
      self:raise "invalid magic integer"
    end

    local magic_number = self:read(header.sizeof_number)
    if ieee754.decode(header.endian, header.sizeof_number, magic_number) == 370.5 then
      header.number = "ieee754"
    elseif integer.decode(header.endian, "i", header.sizeof_number, magic_number) == 370 then
      header.number = "integer"
    end
  end

  function self:read_header()
    local header = {}
    self._header = header

    if self:read(#SIGNATURE) ~= SIGNATURE then
      self:raise "invalid signature"
    end

    local version = self:read_byte()
    if version < 81 or 84 < version then
      self:raise "unsupported version"
    end
    local minor_version = version % 16
    local major_version = (version - minor_version) / 16
    local version_suffix = string.format("_%d_%d", major_version, minor_version)
    header.minor_version = minor_version
    header.major_version = major_version
    self._version_suffix = version_suffix

    local format = self:read_byte()
    if format ~= 0 then
      self:raise "unsupported format"
    end

    self["read_header" .. version_suffix](self, header)
    return header
  end

  return self
end
