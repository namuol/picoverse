function rot (p)
  local s = sin(p.ang)
  local c = cos(p.ang)
  local px = p.x
  local py = p.y
  px -= p.cx
  py -= p.cy
  local xn = px * c - py * s
  local yn = px * s + py * c
  px = xn + p.cx
  py = yn + p.cy
  return px, py
end

return rot