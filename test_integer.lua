local integer = require "dromozoa.integer"

local function test(u, size, specifier)
  local s = integer.encode(u, size, specifier, "<")
  assert(#s == size)
  local v = integer.decode(s, specifier, "<")
  print(u, v)
  assert(u == v)
end

for i = 4, 8, 4 do
  io.write(test(0x00000000, i, "I"))
  io.write(test(0x00000001, i, "I"))
  io.write(test(0x7FFFFFFF, i, "I"))
  io.write(test(0xFFFFFFFF, i, "I"))

  io.write(test(1, i, "i"))
  io.write(test(0, i, "i"))
  io.write(test(-1, i, "i"))
  io.write(test(2147483647, i, "i"))
  io.write(test(-2147483647, i, "i"))
  io.write(test(-2147483648, i, "i"))
end

io.write(test(2^53, 8, "I"))
io.write(test(2^53, 8, "i"))
io.write(test(-2^53, 8, "i"))
