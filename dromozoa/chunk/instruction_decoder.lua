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

return function (version)
  local self = {
    _map = {};
  }

  function self:initialize(set)
    local set = instruction_sets[version]
    local map = self._map
    for i = 1, #set do
      local v = set[i]
      map[v[1]] = {
        mnemonic = v[2];
        mode = v[7];
      }
    end
  end

  function self:decode_ABC(mnemonic, operand)
    local a = operand % 256
    local bc = (operand - a) / 256
    local c = bc % 512
    local b = (bc - c) / 512
    return { mnemonic, a, b, c }
  end

  function self:decode_ABx(mnemonic, operand)
    local a = operand % 256
    local b = (operand - a) / 256
    return { mnemonic, a, b }
  end

  function self:decode_AsBx(mnemonic, operand)
    local a = operand % 256
    local b = (operand - a) / 256 - 0x0001FFFF
    return { mnemonic, a, b }
  end

  function self:decode_Ax(mnemonic, operand)
    return { mnemonic, operand }
  end

  function self:decode(instruction)
    local opcode = instruction % 64
    local operand = (instruction - opcode) / 64
    local v = self._map[opcode]
    return self["decode_" .. v.mode](self, v.mnemonic, operand)
  end

  self:initialize(instruction_sets[version])
  return self
end
