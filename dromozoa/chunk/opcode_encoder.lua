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
      map[v[2]] = {
        opcode = v[1];
        b_mode = v[5];
        c_mode = v[6];
        mode = v[7];
      }
    end
  end

  function self:encode_ABC(opcode, b_mode, c_mode, code)
    local a = code[2]
    local b = 0
    local c = 0
    local i = 3
    if b_mode ~= "N" then
      b = code[i]
      i = i + 1
    end
    if c_mode ~= "N" then
      c = code[i]
      i = i + 1
    end
    if b < 0 then
      b = 255 - b
    end
    if c < 0 then
      c = 255 - c
    end
    assert(0 <= a and a < 256)
    assert(0 <= b and b < 512)
    assert(0 <= c and c < 512)
    return opcode + (a + (b * 512 + c) * 256) * 64
  end

  function self:encode_ABx(opcode, b_mode, c_mode, code)
    local a = code[2]
    local b = 0
    if b_mode == "K" then
      b = -(code[3] + 1)
    elseif b_mode == "U" then
      b = code[3]
    end
    assert(0 <= a and a < 256)
    assert(0 <= b and b < 262144)
    return opcode + (a + b * 256) * 64
  end

  function self:encode_AsBx(name, b_mode, c_mode, code)
    local a = code[2]
    local b = code[3] + 131071
    assert(0 <= a and a < 256)
    assert(0 <= b and b < 262144)
    return opcode + (a + b * 256) * 64
  end

  function self:encode_AsBx(name, b_mode, c_mode, code)
    local a = -(code[2] + 1)
    assert(0 <= a and a < 67108864)
  end

  function self:encode(code)
    local v = self._map[code[1]]
    return self["encode_" .. v.mode](self, v.opcode, v.b_mode, v.c_mode, code)
  end

  self:initialize(opcodes[version])
  return self
end
