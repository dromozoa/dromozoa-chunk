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
  ["5.1"] = require "dromozoa.chunk.opcodes_5_1";
  ["5.2"] = require "dromozoa.chunk.opcodes_5_2";
  ["5.3"] = require "dromozoa.chunk.opcodes_5_3";
}

local unpack = table.unpack or unpack

local mode = ...

local m = 0
local map = {}
for k, v in pairs(opcodes) do
  for i = 1, #v do
    local instruction = v[i]
    local opcode = instruction[1]
    if m < opcode then
      m = opcode
    end
    local name = instruction[2]
    local t = map[name]
    if t then
      t[k] = instruction
    else
      map[name] = { [k] = instruction }
    end
  end
end
m = m + 1

local tbl = {}
for k, v in pairs(map) do
  v.name = k
  v["5.1"] = v["5.1"] or { m }
  v["5.2"] = v["5.2"] or { m }
  v["5.3"] = v["5.3"] or { m }
  tbl[#tbl + 1] = v
end

table.sort(tbl, function (a, b)
  local u = a["5.3"][1]
  local v = b["5.3"][1]
  if u == v then
    u = a["5.2"][1]
    v = b["5.2"][1]
    if u == v then
      u = a["5.1"][1]
      v = b["5.1"][1]
    end
  end
  return u < v
end)

local header = {
  "Name",
  "5.1", "T", "A", "B", "C", "Mode",
  "5.2", "T", "A", "B", "C", "Mode",
  "5.3", "T", "A", "B", "C", "Mode",
}

local function push(out, instruction)
  local opcode, name, t, a, b, c, mode = unpack(instruction)
  if opcode < m then
    out[#out + 1] = opcode
    out[#out + 1] = t and "1" or "0"
    out[#out + 1] = a and "1" or "0"
    out[#out + 1] = b
    out[#out + 1] = c
    out[#out + 1] = mode
  else
    for i = 1, 6 do
      out[#out + 1] = ""
    end
  end
end

if mode == "tsv" then
  io.write(table.concat(header, "\t"), "\n")
  for i = 1, #tbl do
    local v = tbl[i]
    local out = { v.name }
    push(out, v["5.1"])
    push(out, v["5.2"])
    push(out, v["5.3"])
    io.write(table.concat(out, "\t"), "\n")
  end
else
  io.write(table.concat(header, "|"), "\n")
  io.write(string.rep("----", #header, "|"), "\n")
  for i = 1, #tbl do
    local v = tbl[i]
    local out = { v.name }
    push(out, v["5.1"])
    push(out, v["5.2"])
    push(out, v["5.3"])
    io.write(table.concat(out, "|"), "\n")
  end

  io.write [[

Mask|Description
----|----
N|argument is not used
U|argument is used
R|argument is a register or a jump offset
K|argument is a constant or register/constant
]]
end
