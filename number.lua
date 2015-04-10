#! /usr/bin/env lua

-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-assembler.
--
-- dromozoa-assembler is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-assembler is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-assembler.  If not, see <http://www.gnu.org/licenses/>.

local DBL_MAX = 1.7976931348623157e+308
local DBL_DENORM_MIN = 4.9406564584124654e-324
local DBL_MIN = 2.2250738585072014e-308
local DBL_EPSILON = 2.2204460492503131e-16
local nan = math.sqrt(-1)

local unpack = table.unpack or unpack

local encode_binary

if string.pack then
  encode_binary = function (v)
    return string.pack("<d", v)
  end
else
  encode_binary = function (v)
    local buffer
    if -math.huge < v and v < math.huge then
      if v == 0 then
        buffer = { 0, 0, 0, 0, 0, 0, 0, 0 }
      elseif v < DBL_MIN then
        local s = v < 0
        local m, e = math.frexp(v)
        local f = math.ldexp(m, e + 1022)
        print(m, e, f)

        for i = 1, 13 do
          local a = f * 16
          local b = math.floor(a)
          print(string.format("%02x", b))
          f = a - b
        end

      else
        local s = v < 0
        local m, e = math.frexp(v)
        print("e", e)
        local f = m * 2 - 1
        e = e - 1
        e = e + 1023

        local ab = (s and 0x8000 or 0x0000) + e * 16
        print(s, f, e, string.format("%04x", ab))

        for i = 1, 13 do
          local a = f * 16
          local b = math.floor(a)
          print(string.format("%02x", b))
          f = a - b
        end
      end

      os.exit()
    elseif v == math.huge then -- INF
      buffer = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x7F }
    elseif v == -math.huge then -- -INF
      buffer = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xFF }
    else -- Quiet NaN
      buffer = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF8, 0xFF }
    end
    return string.char(unpack(buffer))
  end
end

-- io.write(encode_binary(0))
-- io.write(encode_binary(DBL_MIN))
io.write(encode_binary(2^-1030))
-- io.write(encode_binary(math.pi))
-- io.write(encode_binary(math.huge))
-- io.write(encode_binary(-math.huge))
-- io.write(encode_binary(nan))

os.exit()

local x = DBL_MAX * 2
local nan = math.sqrt(-1)
local inf = math.huge

local x = inf
print(x <= inf)
