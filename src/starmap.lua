component = require('component')
dist = require('dist')

function draw_star(props)
  local color
  local pos = props.star.pos
  if dist(pos, props.player_pos) > props.player_range then
    color = indigo
  else
    color = white
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
end

return starmap