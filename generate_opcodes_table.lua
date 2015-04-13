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

local opcodes_5_1 = require "dromozoa.chunk.opcodes_5_1"
local opcodes_5_2 = require "dromozoa.chunk.opcodes_5_2"
local opcodes_5_3 = require "dromozoa.chunk.opcodes_5_3"

local unpack = table.unpack or unpack

local opcodes = {
  { "5.1", opcodes_5_1 };
  { "5.2", opcodes_5_2 };
  { "5.3", opcodes_5_3 };
}

local table = {}
for i = 1, #opcodes_5_1 do
  local opcode = opcodes_5_1[i]
  local t = table[opcode[2]]
  if t then
    t["5.1"] = opcode
  else
    table[opcode[2]] = { ["5.1"] = opcode }
  end
end
for i = 1, #opcodes_5_2 do
  local opcode = opcodes_5_2[i]
  local t = table[opcode[2]]
  if t then
    t["5.2"] = opcode
  else
    table[opcode[2]] = { ["5.2"] = opcode }
  end
end
for i = 1, #opcodes_5_3 do
  local opcode = opcodes_5_3[i]
  local t = table[opcode[2]]
  if t then
    t["5.3"] = opcode
  else
    table[opcode[2]] = { ["5.3"] = opcode }
  end
end

for k, v in pairs(table) do
  io.write(k)
  local opcode_5_1 = v["5.1"]
  local opcode_5_2 = v["5.2"]
  local opcode_5_3 = v["5.3"]
  if opcode_5_1 then
    io.write("\t", opcode_5_1[1], "\t", opcode_5_1[7])
  else
    io.write("\t\t")
  end
  if opcode_5_2 then
    io.write("\t", opcode_5_2[1], "\t", opcode_5_2[7])
  else
    io.write("\t\t")
  end
  if opcode_5_3 then
    io.write("\t", opcode_5_3[1], "\t", opcode_5_3[7])
  else
    io.write("\t\t")
  end
  io.write "\n"
end
