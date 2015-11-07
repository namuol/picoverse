local galaxymap = {}

function galaxymap.init(props)
  pal()
  color(white)
  props = props or {
    rotation=0,
    scale=0,
  }

  local get_y = function(t,i)
    return max(0, 8 - 8*((t - 1)-i*0.05))
    -- return 4*sin(t-i*0.1)
  end

  props.title_printer = make_printer(
    function(t,i)
      return 0
    end,
    get_y,
    function(t,i)
      local y = get_y(t,i)
      if y > 4 then
        return black
      elseif y > 3 then
        return dark_blue
      elseif y > 2 then
        return dark_gray
      elseif y > 1 then
        return light_gray
      else
        return white
      end
    end,
    20
  )

  return props
end

function galaxymap.update(props)
  props.rotation -= 0.0005
  props.title_printer.update()
  props.scale = min(1, props.scale + 0.05)
  return props
end

srand(42)
local objs = {}
for x=0,15 do
  for y=0,15 do
    local s = mget(x,y)/255
    if s > 0.1 then
      local tbl = {}
      objs[y*15+x] = tbl
      for n=1,2+rnd(24)*s do
        add(tbl, {x=rnd(8)-rnd(8), y=rnd(8)-rnd(8),r=rnd(1)})
      end
    end
  end
end

function galaxymap.draw(props)
  cls()
  for x=0,15 do
    for y=0,15 do
      local size = mget(x,y)/255
      local orbs = objs[y*15+x]
      if size > 0.1 then
        for i,orb in pairs(orbs) do
          local px, py = rot({x=x*8+4+orb.x,y=y*8+4+orb.y, cx=64,cy=64, ang=props.rotation})
          -- circfill(px,py, orb.r*size*3, mget(x+16,y))
          circfill(px*0.9 + 6,py*0.4 + 43, orb.r*size*3, mget(x+16,y))
        end
      end
    end
  end

  props.title_printer.draw('p  i  c  o  v  e  r  s  e', 10, 12)
end

return galaxymap