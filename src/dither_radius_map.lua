function dither(d)
  return clamp(flr(d * 32), 0, 32)
end

function dither_radius_map(props)
  local penumbra = props.penumbra or 1
  local range = props.radius + penumbra
  local mx = props.mx or 0
  local my = props.my or 0

  for x=mx,mx+16 do
    for y=my,my+16 do
      local t
      
      local d = dist(props.pos, {x=x*8+4,y=y*8+4})

      if d < range then
        t = dither((range - d)/penumbra)
      end

      mset(x,y, t)
    end
  end
end

return dither_radius_map