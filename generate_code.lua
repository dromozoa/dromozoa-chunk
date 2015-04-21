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

local set = {}
local m = 0

for line in io.lines() do
  local opmode, name = line:match("opmode%((.-)%)%s*/%* OP_(.-) %*/")
  if opmode then
    local t, a, b, c, mode = opmode:match("^([01]),%s*([01]),%s*OpArg([^%s,]+),%s*OpArg([^%s,]+),%s*i([^%s,]+)$")
    assert(t)
    set[#set + 1] = { name, t, a, b, c, mode }
    local n = #name
    if m < n then
      m = n
    end
  end
end

io.write "return {\n"
for i = 1, #set do
  local name, t, a, b, c, mode = unpack(set[i])
  io.write(
      format(
          "  { 0x%02X, %-" .. (m + 3) .. "s %-6s %-6s %q, %q, %-6s };\n",
          i - 1,
          format("%q,", name),
          format("%s,", t == "1" and "true" or "false"),
          format("%s,", a == "1" and "true" or "false"),
          b,
          c,
          format("%q", mode)))
end
io.write "}\n"
