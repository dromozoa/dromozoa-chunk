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

local swap = require "dromozoa.chunk.swap"

if string.pack then
  return {
    decode = function (endian, specifier, size, s, position)
      return ((endian .. specifier .. size):unpack(s, position))
    end;

    encode = function (endian, specifier, size, v)
      return (endian .. specifier .. size):pack(v)
    end;
  }
else
  local unpack = table.unpack or unpack

  return {
    decode = function (endian, specifier, size, s, position)
      if not position then
        position = 1
      end
      local buffer = { s:byte(position, position + size - 1) }
      if endian == ">" then
        swap(buffer)
      end
      if specifier == "i" and buffer[size] > 127 then
        local v = 0
        for i = size, 1, -1 do
          v = v * 256 + buffer[i] - 255
        end
        return v - 1
      else
        local v = 0
        for i = size, 1, -1 do
          v = v * 256 + buffer[i]
        end
        return v
      end
    end;

    encode = function (endian, specifier, size, v)
      local buffer = {}
      if specifier == "i" and v < 0 then
        v = -(v + 1)
        for i = 1, size do
          local u = v % 256
          buffer[i] = 255 - u
          v = (v - u) / 256
        end
      else
        for i = 1, size do
          local u = v % 256
          buffer[i] = u
          v = (v - u) / 256
        end
      end
      if endian == ">" then
        swap(buffer)
      end
      return string.char(unpack(buffer))
    end;
  }
end
