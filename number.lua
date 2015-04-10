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
    local sign = 0
    local exponent = 0
    local fraction = 0

    if -math.huge < v and v < math.huge then
      if v == 0 then
        if string.format("%.17g", v):sub(1, 1) == "-" then
          sign = 1
        end
      else
        if v < 0 then
          sign = 1
        end
        local m, e = math.frexp(v)
        if e < -1021 then
          fraction = math.ldexp(m, e + 1022)
        else
          exponent = e + 1022
          fraction = m * 2 - 1
        end
      end
    elseif v == math.huge then
      exponent = 2047
    elseif v == -math.huge then
      sign = 1
      exponent = 2047
    else
      sign = 1
      exponent = 2047
      fraction = 0.5
    end

    local buffer = {}

    local a = exponent % 16
    buffer[1] = sign * 128 + (exponent - a) / 16

    local f = fraction * 16
    local b = math.floor(f)
    f = f - b
    buffer[2] = a * 16 + b

    for i = 3, 8 do
      f = f * 256
      b = math.floor(f)
      f = f - b
      buffer[i] = b
    end

    for i = 1, 4 do
      buffer[i], buffer[9 - i] = buffer[9 - i], buffer[i]
    end

    return string.char(unpack(buffer))
  end
end

local sign_zero = -DBL_MIN / 256^7

io.write(encode_binary(sign_zero))
io.write(encode_binary(0))
io.write(encode_binary(DBL_MAX))
io.write(encode_binary(DBL_MIN))
io.write(encode_binary(2^-1030))
io.write(encode_binary(math.pi))
io.write(encode_binary(math.huge))
io.write(encode_binary(-math.huge))
io.write(encode_binary(nan))
