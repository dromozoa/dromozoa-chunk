if string.pack then
  local function format(endian, n)
    if not endian then
      endian = "="
    end
    if n == 4 then
      return endian .. "f"
    elseif n == 8 then
      return endian .. "d"
    else
      return endian .. "n"
    end
  end

  return {
    decode_binary = function (s, endian)
      return (format(endian, #s):unpack(s))
    end;
    encode_binary = function (v, n, endian)
      return format(endian, n):pack(v)
    end;
  }
else
  local unpack = table.unpack or unpack

  local function constant(n)
    if n == 4 then
      return 126, 255, 128
    elseif n == 8 then
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

  local function decode_sign_exponent(a, b, shift)
    local sign = 1
    local exponent = a % 128
    if a - exponent == 128 then
      sign = -1
    end
    return sign, exponent * shift + math.floor(b / shift)
  end

  local function encode_fraction(v, shift)
    local a = v * shift
    local b = math.floor(a)
    return a - b, b
  end

  local function encode_exponent(v, shift)
    local a = v * shift
    local b = a % 256
    return (a - b) / 256, b
  end

  return {
    decode_binary = function (s, endian)
      local bias, fill, shift = constant(#s)

      local buffer = { s:byte(1, -1) }
      if endian == "<" then
        swap(buffer)
      end

      local a, b = buffer[1], buffer[2]
      local sign, exponent = decode_sign_exponent(a, b, shift)
      local fraction = 0

      for i = #buffer, 3, -1 do
        fraction = (fraction + buffer[i]) / 256
      end
      fraction = (fraction + b % shift) / shift

      local m, e
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
          m = fraction
          e = exponent - bias
        end
      else
        m = (fraction + 1) / 2
        e = exponent - bias
      end
      return sign * math.ldexp(m, e)
    end;

    encode_binary = function (v, n, endian)
      local bias, fill, shift = constant(n)

      local sign = 0
      local exponent = 0
      local fraction = 0

      if -math.huge < v and v < math.huge then
        if v == 0 then
          if string.format("%g", v):sub(1, 1) == "-" then
            sign = 0x80
          end
        else
          if v < 0 then
            sign = 0x80
          end
          local m, e = math.frexp(v)
          if e <= -bias then
            fraction = math.ldexp(m, e + bias)
          else
            exponent = e + bias
            fraction = m * 2 - 1
          end
        end
      elseif v == math.huge then
        exponent = fill
      elseif v == -math.huge then
        sign = 0x80
        exponent = fill
      else
        sign = 0x80
        exponent = fill
        fraction = 0.5
      end

      local buffer = {}

      fraction, buffer[2] = encode_fraction(fraction, shift)
      for i = 3, n do
        fraction, buffer[i] = encode_fraction(fraction, 256)
      end

      local a, b = encode_exponent(exponent, shift)
      buffer[1] = sign + a
      buffer[2] = buffer[2] + b

      if endian == "<" then
        swap(buffer)
      end
      return string.char(unpack(buffer))
    end;
  }
end
