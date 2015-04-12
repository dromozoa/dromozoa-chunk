if string.pack then
  local function format(endian, size)
    if size == 4 then
      return endian .. "f"
    elseif size == 8 then
      return endian .. "d"
    end
  end

  return {
    decode = function (endian, s)
      return (format(endian, #s):unpack(s))
    end;

    encode = function (endian, size, v)
      return format(endian, size):pack(v)
    end;
  }
else
  local unpack = table.unpack or unpack

  local function constant(size)
    if size == 4 then
      return 126, 255, 128
    elseif size == 8 then
      return 1022, 2047, 16
    end
  end

  local function swap(buffer)
    local n = #buffer
    for i = 1, n / 2 do
      local j = n - i + 1
      buffer[i], buffer[j] = buffer[j], buffer[i]
    end
  end

  return {
    decode = function (endian, s)
      local bias, fill, shift = constant(#s)

      local buffer = { s:byte(1, -1) }
      if endian == "<" then
        swap(buffer)
      end

      local a, b = buffer[1], buffer[2]
      local sign = a < 128 and 1 or -1
      local exponent = a % 128 * shift + math.floor(b / shift)
      local fraction = 0
      for i = #buffer, 3, -1 do
        fraction = (fraction + buffer[i]) / 256
      end
      fraction = (fraction + b % shift) / shift

      if exponent == fill then
        if fraction == 0 then
          return sign * math.huge
        else
          return 0 / 0
        end
      elseif exponent == 0 then
        if fraction == 0 then
          if sign > 0 then
            return 0
          else
            return -1 / math.huge
          end
        else
          return sign * math.ldexp(fraction, exponent - bias)
        end
      else
        return sign * math.ldexp((fraction + 1) / 2, exponent - bias)
      end
    end;

    encode = function (endian, size, v)
      local bias, fill, shift = constant(size)

      local sign = 0
      local exponent = 0
      local fraction = 0

      if -math.huge < v and v < math.huge then
        if v == 0 then
          if string.format("%g", v):sub(1, 1) == "-" then
            sign = 0x8000
          end
        else
          if v < 0 then
            sign = 0x8000
          end
          local m, e = math.frexp(v)
          if e <= -bias then
            fraction = math.ldexp(m, e + bias)
          else
            exponent = e + bias
            fraction = m * 2 - 1
          end
        end
      else
        exponent = fill
        if v ~= math.huge then
          sign = 0x8000
          if v ~= -math.huge then
            fraction = 0.5
          end
        end
      end

      local buffer = {}
      local b, fraction = math.modf(fraction * shift)
      for i = 3, size do
        buffer[i], fraction = math.modf(fraction * 256)
      end
      local ab = sign + exponent * shift + b
      buffer[1] = math.floor(ab / 256)
      buffer[2] = ab % 256

      if endian == "<" then
        swap(buffer)
      end
      return string.char(unpack(buffer))
    end;
  }
end
