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

local number = require "dromozoa.number"

local DBL_MAX = 1.7976931348623157e+308
local DBL_DENORM_MIN = 4.9406564584124654e-324
local DBL_MIN = 2.2250738585072014e-308
local DBL_EPSILON = 2.2204460492503131e-16
local nan = math.sqrt(-1)

-- io.write(number.encode_binary(0.125, 8, "<"))
print(number.decode_binary(number.encode_binary(DBL_MIN, 8, "<"), "<"))
-- io.write(number.encode_binary(0.375, 4, ">"))
os.exit()

local unpack = table.unpack or unpack

local encode_binary
local decode_binary

if string.pack then
  encode_binary = function (v)
    return string.pack("<d", v)
  end

  decode_binary = function (v)
    return string.unpack("<d", v)
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

    io.stderr:write(string.format("E %d,%d,%.17g\n", sign, exponent, fraction))

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

  decode_binary = function (v)
    local buffer = { v:byte(1, -1) }
    for i = 1, 4 do
      buffer[i], buffer[9 - i] = buffer[9 - i], buffer[i]
    end

    local sign = 0
    local exponent = 0
    local fraction = 0

    local a = buffer[1]
    local b = a % 128

    if a - b == 128 then
      sign = 1
    end
    exponent = b * 16

    local a = buffer[2]
    local b = a % 16
    exponent = exponent + (a - b) / 16
    fraction = b

    local f = 0
    for i = 8, 3, -1 do
      f = f / 256
      f = f + buffer[i]
    end
    f = f / 256

    fraction = (fraction + f) / 16

    if exponent == 2047 then
      if fraction == 0 then
        if sign == 0 then
          io.stderr:write("= INF\n")
          return math.huge
        else
          io.stderr:write("= -INF\n")
          return -math.huge
        end
      else
        io.stderr:write("= NaN\n")
        return 0 / 0
      end
    elseif exponent == 0 and fraction == 0 then
      if sign == 0 then
        io.stderr:write("= 0\n")
        return 0
      else
        io.stderr:write("= -0\n")
        return -1 / math.huge
      end
    else
      local m, e
      if exponent == 0 then
        m = fraction
        e = exponent - 1022
      else
        m = (fraction + 1) / 2
        e = exponent - 1022
      end
      io.stderr:write(string.format("= %.17g\n", math.ldexp(m, e)))
      return math.ldexp(m, e)
    end

    io.stderr:write(string.format("D %d,%d,%.17g\n", sign, exponent, fraction))
  end
end

local sign_zero = -DBL_MIN / 256^7

local function test(v)
  io.stderr:write(string.format("? %.17g\n", v))
  print(decode_binary(encode_binary(v)))
  io.stderr:write("\n")
end

test(sign_zero)
test(0)
test(DBL_MAX)
test(DBL_MIN)
test(2^-1030)
test(math.pi)
test(math.huge)
test(-math.huge)
test(nan)
