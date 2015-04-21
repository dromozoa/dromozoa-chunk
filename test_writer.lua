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

local reader = require "dromozoa.chunk.reader"
local writer = require "dromozoa.chunk.writer"

function buffer_reader(s)
  local self = {
    _s = s;
    _i = 1;
  }

  function self:read(n)
    local i = self._i
    local j = i + n - 1
    self._i = j + 1
    return self._s:sub(i, j)
  end

  return self
end

function buffer_writer()
  local self = {
    _t = {}
  }

  function self:write(s)
    local t = self._t
    t[#t + 1] = s
  end

  function self:concat()
    return table.concat(self._t)
  end

  return self
end

local s = string.dump(function () print(0.25, 0.5) end)
local br = buffer_reader(s)
local r = reader(br)
local chunk = r:read_chunk()

-- local constants = chunk.body.constants
-- for i = 1, #constants do
--   local v = constants[i]
--   if v == 0.25 then
--     constants[i] = 4
--   end
-- end

local bw = buffer_writer()
local w = writer(bw)
w:write_chunk(chunk)

assert(s == bw:concat())
io.write(bw:concat())
