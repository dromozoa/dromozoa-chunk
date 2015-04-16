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

local opcodes = {
  [81] = require "dromozoa.chunk.opcodes_5_1";
  [82] = require "dromozoa.chunk.opcodes_5_2";
  [83] = require "dromozoa.chunk.opcodes_5_3";
}

return function (version)
  local self = {
    _map = {};
  }

  function self:initialize(set)
    local set = opcodes[version]
    local map = self._map
    for i = 1, #set do
      local v = set[i]
      map[v[1]] = {
        name = v[2];
        is_t = v[3];
        is_a = v[4];
        b_mode = v[5];
        c_mode = v[6];
        mode = v[7];
      }
    end
  end

  function self:decode_ABC(name, b_mode, c_mode, operand)
    local a = operand % 256
    local bc = (operand - a) / 256
    local c = bc % 512
    local b = (bc - c) / 512
    if b > 255 then
      b = -(b % 256 + 1)
    end
    if c > 255 then
      c = -(c % 256 + 1)
    end
    local result = { name, a }
    if b_mode ~= "N" then
      result[#result + 1] = b
    end
    if c_mode ~= "N" then
      result[#result + 1] = c
    end
    return result
  end

  function self:decode_ABx(name, b_mode, c_mode, operand)
    local a = operand % 256
    local b = (operand - a) / 256
    local result = { name, a }
    if b_mode == "K" then
      result[#result + 1] = -(b + 1)
    elseif b_mode == "U" then
      result[#result + 1] = b
    end
    return result
  end

  function self:decode_AsBx(name, b_mode, c_mode, operand)
    local a = operand % 256
    local b = (operand - a) / 256 - 0x0001FFFF
    return { name, a, b }
  end

  function self:decode_Ax(name, b_mode, c_mode, operand)
    return { name, -(operand + 1) }
  end

  function self:decode(instruction)
    local opcode = instruction % 64
    local operand = (instruction - opcode) / 64
    local v = self._map[opcode]
    return self["decode_" .. v.mode](self, v.name, v.b_mode, v.c_mode, operand)
  end

  self:initialize(opcodes[version])
  return self
end
