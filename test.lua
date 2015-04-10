local integer = require "dromozoa.integer"





io.write(integer.encode(-1, 2, "signed", ">"))
io.write(integer.encode(-32768, 2, "signed", ">"))
-- io.write(integer.encode(65535, 2, "unsigned", ">"))
-- print(integer.decode("\254\253\0\0\255\255\255\255", "signed", "<"))
-- print(integer.decode("\127\127\100\100", "signed", "<"))

