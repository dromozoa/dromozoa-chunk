local integer = require "dromozoa.chunk.integer"

local function test(specifier, size, u)
  local s = integer.encode("<", specifier, size, u)
  assert(#s == size)
  local v = integer.decode("<", specifier, size, s)
  assert(u == v)
end

for i = 4, 8, 4 do
  io.write(test("I", i, 0x00000000))
  io.write(test("I", i, 0x00000001))
  io.write(test("I", i, 0x7FFFFFFF))
  io.write(test("I", i, 0xFFFFFFFF))
  io.write(test("i", i,  1))
  io.write(test("i", i,  0))
  io.write(test("i", i, -1))
  io.write(test("i", i,  2147483647))
  io.write(test("i", i, -2147483647))
  io.write(test("i", i, -2147483648))
end

io.write(test("I", 8,  2^53))
io.write(test("i", 8,  2^53))
io.write(test("i", 8, -2^53))

assert(integer.decode("<", "I", 4, "\0\1\2\3\4\5\6\7", 3) == 0x05040302)
