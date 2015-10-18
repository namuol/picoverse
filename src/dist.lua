function dist(a,b)
  local dx = b.x-a.x
  local dy = b.y-a.y
  return sqrt(dx*dx + dy*dy)
end

return dist