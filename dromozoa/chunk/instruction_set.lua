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

local instruction_sets = {
  [81] = require "dromozoa.chunk.instruction_set_5_1";
  [82] = require "dromozoa.chunk.instruction_set_5_2";
  [83] = require "dromozoa.chunk.instruction_set_5_3";
}

local function generate_map(set)
  local map = {}
  for i = 1, #set do
    local v = set[i]
    map[v[2]] = v
  end
  return map
end

return function (set)
  local self = {
    _set = set;
    _map = generate_map(set);
  }

  function self:get_by_opcode(opcode)
    return self._set[opcode + 1]
  end

  function self:get_by_mnemonic(mnemonic)
    return self._map[mnemonic]
  end
end
