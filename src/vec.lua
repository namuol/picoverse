local dist = require('dist')

local vec = {}

local z = {x=0,y=0}

function vec.norm(v)
  local len = dist(z, v)
  return {x=v.x/len,y=v.y/len}
end

function vec.mul(v, s)
  return {x=v.x*s,y=v.y*s}
end

function vec.add(a, b)
  return {x=a.x+b.x,y=a.y+b.y}
end

function vec.sub(a, b)
  return {x=a.x-b.x,y=a.y-b.y}
end

return vec