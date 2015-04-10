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

local ieee754 = require "dromozoa.ieee754"

local DBL_MAX = 1.7976931348623157e+308
local DBL_DENORM_MIN = 4.9406564584124654e-324
local DBL_MIN = 2.2250738585072014e-308
local DBL_EPSILON = 2.2204460492503131e-16
local nan = math.sqrt(-1)

local function is_nan(v)
  return not (-math.huge <= v and v <= math.huge)
end

local function test(u)
  local s = ieee754.encode(u, 8, "<")
  -- io.write(s)
  local v = ieee754.decode(s, "<")
  print("<", u)
  print(">", v)
  if is_nan(u) then
    assert(is_nan(v))
  else
    assert(u == v)
  end
end

test(-1 / math.huge)
test(0)
test(DBL_MAX)
test(DBL_MIN)
test(math.pi)
test(2^-1030)
test(math.huge)
test(-math.huge)
test(nan)
