local M = {}

-- string padding
M.pad_string = function(str, len, align)
  local str_len = #str
  if str_len >= len then
    return str
  end

  local pad_len = len - str_len
  local pad = string.rep(" ", pad_len)

  if align == "left" then
    return str .. pad
  elseif align == "right" then
    return pad .. str
  elseif align == "center" then
    local left_pad = math.floor(pad_len / 2)
    local right_pad = pad_len - left_pad
    return string.rep(" ", left_pad) .. str .. string.rep(" ", right_pad)
  end
end

-- create colour gradient from hex values
M.create_gradient = function(start, finish, steps)
  local r1, g1, b1 =
      tonumber("0x" .. start:sub(2, 3)), tonumber("0x" .. start:sub(4, 5)), tonumber("0x" .. start:sub(6, 7))
  local r2, g2, b2 =
      tonumber("0x" .. finish:sub(2, 3)), tonumber("0x" .. finish:sub(4, 5)), tonumber("0x" .. finish:sub(6, 7))

  local r_step = (r2 - r1) / steps
  local g_step = (g2 - g1) / steps
  local b_step = (b2 - b1) / steps

  local gradient = {}
  for i = 1, steps do
    local r = math.floor(r1 + r_step * i)
    local g = math.floor(g1 + g_step * i)
    local b = math.floor(b1 + b_step * i)
    table.insert(gradient, string.format("#%02x%02x%02x", r, g, b))
  end

  return gradient
end

return M
