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

local json = require "dromozoa.json"

local unpack = table.unpack or unpack
local format = string.format
local lower = string.lower

local filename = {...}

local function read_map(filename)
  local handle = assert(io.open(filename))
  local content = handle:read("*a")
  handle:close()

  local map = {}
  for line in content:gmatch("\n(OP_.-,?/%*.-%*/)") do
    local name, args, desc = line:match("^OP_(.-),?/%*\t+(.-)\t+(.-)%s*%*/$")
    assert(name)
    desc = desc:gsub("%s+", " ")
    map[name] = {
      args = args;
      desc = desc;
    }
  end
  return map
end

local map = {
  ["5.1"] = read_map(filename[1]);
  ["5.2"] = read_map(filename[2]);
  ["5.3"] = read_map(filename[3]);
}

local data = {}

local i = 1
for line in io.lines() do
  if i > 1 then
    local name = line:match("^(.-)\t")
    assert(name)
    local row = {}
    for j in line:gmatch("\t([^\t]*)") do
      row[#row + 1] = j
    end
    local v = {
      name = name;
    }
    data[#data + 1] = v
    for j = 1, 3 do
      local version = "5." .. j
      local k = (j - 1) * 6
      local opcode = row[k + 1]
      if opcode == "" then
        v[version] = {}
      else
        v[version] = {
          opcode = tonumber(opcode);
          t = tonumber(row[k + 2]);
          a = tonumber(row[k + 3]);
          b = row[k + 4];
          c = row[k + 5];
          mode = row[k + 6]
        }
        v[version].args = map[version][name].args
        v[version].desc = map[version][name].desc
      end
    end
  end
  i = i + 1
end

io.write("## Contents\n\n")
for i = 1, #data do
  local v = data[i]
  io.write(format("* [%s](#%s)\n", v.name, lower(v.name)))
end
io.write("\n")

for i = 1, #data do
  local u = data[i]
  io.write(format("## %s\n\n", u.name))
  io.write("| Ver. | Code | T | A | B | C | Mode | Args  | Desc\n")
  io.write("|:----:|:----:|:-:|:-:|:-:|:-:|:-----|:------|:---------------------------------\n")
  for j = 1, 3 do
    local version = "5." .. j
    local v = u[version]
    if v.opcode then
      local desc = v.desc
      if desc:match "|" then
        desc = "<code>" .. desc:gsub("|", "&#124;") .. "</code>"
      else
        desc = "`" .. desc .. "`"
      end

      io.write(
          format(
              "| %s  | 0x%02X | %d | %d | %s | %s | %-4s | %-5s | %s\n",
              version,
              v.opcode,
              v.t,
              v.a,
              v.b,
              v.c,
              v.mode,
              v.args,
              desc))
    end
  end
  io.write("\n")
end
