local component = require('component')
local dist = require('dist')
local sprites = require('sprites')

function draw_star(props)
  local color
  local pos = props.star.pos
  if dist(pos, props.player_pos) > props.player_range then
    color = indigo
  else
    color = white
  end

  if props.star.visited then
    circ(pos.x, pos.y, 2, indigo)
  end

  if props.star.mission then
    circ(pos.x, pos.y, 2, yellow)
  end

  pset(pos.x, pos.y, color)
end

starmap = {}

function starmap.init(props)
  return props
end

function starmap.update(props)
  return props
end

function starmap.draw(props)
  cls()
  
  circfill(props.player_pos.x, props.player_pos.y, props.player_range, dark_blue)
  
  for n,star in pairs(props.stars) do
    local star = props.stars[n]
    draw_star({
      star=star,
      player_pos=props.player_pos,
      player_range=props.player_range,
    })
  end

  spr(sprites.indicator, props.player_pos.x-3, props.player_pos.y-9)
end

return starmap