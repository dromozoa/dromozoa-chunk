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

local ieee754 = require "dromozoa.chunk.ieee754"

local DBL_MAX = 1.7976931348623157e+308
local DBL_DENORM_MIN = 4.9406564584124654e-324
local DBL_MIN = 2.2250738585072014e-308
local DBL_EPSILON = 2.2204460492503131e-16

local function test(u)
  local s = ieee754.encode("<", 8, u)
  assert(#s == 8)
  local v = ieee754.decode("<", s)
  if -math.huge <= u and u <= math.huge then
    assert(u == v)
  else
    assert(not (-math.huge <= v and v <= math.huge))
  end
end

test(DBL_MAX)
test(DBL_DENORM_MIN)
test(DBL_MIN)
test(DBL_EPSILON)
test(math.pi)
test(0)
test(-1 / math.huge) -- -0
test(math.huge)      -- inf
test(-math.huge)     -- -inf
test(0 / 0)          -- nan
