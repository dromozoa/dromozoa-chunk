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

local tsv = false

local opcodes = {
  { "5.1", opcodes_5_1 };
  { "5.2", opcodes_5_2 };
  { "5.3", opcodes_5_3 };
}

local map = {}
for i = 1, #opcodes_5_1 do
  local opcode = opcodes_5_1[i]
  local t = map[opcode[2]]
  if t then
    t["5.1"] = opcode
  else
    map[opcode[2]] = { ["5.1"] = opcode }
  end
end
for i = 1, #opcodes_5_2 do
  local opcode = opcodes_5_2[i]
  local t = map[opcode[2]]
  if t then
    t["5.2"] = opcode
  else
    map[opcode[2]] = { ["5.2"] = opcode }
  end
end
for i = 1, #opcodes_5_3 do
  local opcode = opcodes_5_3[i]
  local t = map[opcode[2]]
  if t then
    t["5.3"] = opcode
  else
    map[opcode[2]] = { ["5.3"] = opcode }
  end
end

local tbl = {}
for k, v in pairs(map) do
  v.name = k
  v["5.1"] = v["5.1"] or {}
  v["5.2"] = v["5.2"] or {}
  v["5.3"] = v["5.3"] or {}
  tbl[#tbl + 1] = v
end

table.sort(tbl, function (a, b)
  local u = a["5.3"][1]
  local v = b["5.3"][1]
  if u == nil and v == nil then
    local u = a["5.2"][1]
    local v = b["5.2"][1]
    if u == nil and v == nil then
      local u = a["5.1"][1]
      local v = b["5.1"][1]
      if u == nil or v == nil then
        return v == nil
      end
      return u < v
    end
    if u == nil or v == nil then
      return v == nil
    end
    return u < v
  end
  if u == nil or v == nil then
    return v == nil
  end
  return u < v
end)

if tsv then
  function write_opcode(opcode)
    local code, name, t, a, b, c, mode = unpack(opcode)
    if code then
      io.write("\t", code, "\t", t and "1" or "0", "\t", a and "1" or "0", "\t", b, "\t", c, "\t", mode)
    else
      io.write("\t\t\t\t\t\t")
    end
  end

  for i = 1, #tbl do
    local v = tbl[i]
    io.write(v.name)
    write_opcode(v["5.1"])
    write_opcode(v["5.2"])
    write_opcode(v["5.3"])
    io.write "\n"
  end
else
  function write_opcode(opcode)
    local code, name, t, a, b, c, mode = unpack(opcode)
    if code then
      io.write("|", code, "|", t and "1" or "0", "|", a and "1" or "0", "|", b, "|", c, "|", mode)
    else
      io.write("||||||")
    end
  end

  io.write("|Mnemonic|5.1|T|A|B|C|Mode|5.2|T|A|B|C|Mode|5.3|T|A|B|C|Mode|\n")
  io.write(string.rep("|", 20, "---"), "\n")
  for i = 1, #tbl do
    local v = tbl[i]
    io.write("|", v.name)
    write_opcode(v["5.1"])
    write_opcode(v["5.2"])
    write_opcode(v["5.3"])
    io.write "|\n"
  end
end
