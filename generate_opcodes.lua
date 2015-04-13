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

local unpack = table.unpack or unpack
local format = string.format

local opcodes = {}
local m = 0

for line in io.lines() do
  local opmode, opcode = line:match("opmode%((.-)%)%s*/%* OP_(.-) %*/")
  if opmode then
    local t, a, b, c, mode = opmode:match("^([01]),%s*([01]),%s*OpArg([^%s,]+),%s*OpArg([^%s,]+),%s*i([^%s,]+)$")
    assert(mode)
    opcodes[#opcodes + 1] = { opcode, t, a, b, c, mode }
    local n = #opcode
    if m < n then
      m = n
    end
  end
end

io.write "return {\n"
local n = #opcodes
for i = 1, n do
  local opcode, t, a, b, c, mode = unpack(opcodes[i])
  io.write(
      format(
          "  { 0x%02X, %-" .. (m + 3) .. "s %-6s %-6s %q, %q, %-6s };\n",
          i - 1,
          format("%q,", opcode),
          format("%s,", t == "1" and "true" or "false"),
          format("%s,", a == "1" and "true" or "false"),
          b,
          c,
          format("%q", mode)))
end
io.write "}\n"
