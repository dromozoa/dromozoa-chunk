if string.pack then
  return {
    decode = function (endian, specifier, size, s, position)
      return ((endian .. specifier .. size):unpack(s, position))
    end;

    encode = function (endian, specifier, size, v)
      return (endian .. specifier .. size):pack(v)
    end;
  }
else
  local unpack = table.unpack or unpack

  local function swap(buffer)
    local n = #buffer
    for i = 1, n / 2 do
      local j = n - i + 1
      buffer[i], buffer[j] = buffer[j], buffer[i]
    end
  end

  return {
    decode = function (endian, specifier, size, s, position)
      if not position then
        position = 1
      end
      local buffer = { s:byte(position, position + size - 1) }
      if endian == ">" then
        swap(buffer)
      end
      if specifier == "i" and buffer[size] > 127 then
        local v = 0
        for i = size, 1, -1 do
          v = v * 256 + buffer[i] - 255
        end
        return v - 1
      else
        local v = 0
        for i = size, 1, -1 do
          v = v * 256 + buffer[i]
        end
        return v
      end
    end;

    encode = function (endian, specifier, size, v)
      local buffer = {}
      if specifier == "i" and v < 0 then
        v = -(v + 1)
        for i = 1, size do
          local x = v % 256
          buffer[i] = 255 - x
          v = (v - x) / 256
        end
      else
        for i = 1, size do
          local x = v % 256
          buffer[i] = x
          v = (v - x) / 256
        end
      end
      if endian == ">" then
        swap(buffer)
      end
      return string.char(unpack(buffer))
    end;
  }
end
