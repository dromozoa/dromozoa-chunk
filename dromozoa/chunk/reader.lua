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

  function self:read_int()
    local H = self._header
    local size = H.sizeof_int
    return integer.decode(H.endian, "i", size, self:read(size))
  end

  function self:read_size_t()
    local H = self._header
    local size = H.sizeof_size_t
    return integer.decode(H.endian, "I", size, self:read(size))
  end

  function self:read_integer()
    local H = self._header
    local size = H.sizeof_integer
    return integer.decode(H.endian, "i", size, self:read(size))
  end

  function self:read_number()
    local H = self._header
    local size = H.sizeof_number
    if H.number == "ieee754" then
      return ieee754.decode(H.endian, size, self:read(size))
    else
      return integer.decode(H.endian, "i", size, self:read(size))
    end
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

  return self
end
