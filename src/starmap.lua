local component = require('component')
local dist = require('dist')
local vec = require('vec')

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

function random_starmap_props()
  local stars = times(80, random_star)
  local current_star = stars[1+flr(rnd(#stars))]
  current_star.visited = true
  return {
    player_pos=current_star.pos,
    player_range=5 + rnd(40),
    stars=stars,
    crosshair={
      visible=true,
      x=current_star.pos.x,
      y=current_star.pos.y,
    }
  }
end

function starmap.init(props)
  return props or random_starmap_props()
end

function get_destination_star(stars, pos)
  local closest
  local min_dist = 9999

  for i,star in pairs(stars) do
    local d = dist(star.pos, pos)
    if d < min_dist then
      closest = star
      min_dist = d
      closest._dist = d
    end
  end

  return closest
end

function starmap.update(props)
  local crosshair_moved

  if btn(btn_left) then
    props.crosshair.x -= 1
    crosshair_moved = true
  elseif btn(btn_right) then
    props.crosshair.x += 1
    crosshair_moved = true
  end

  if btn(btn_up) then
    props.crosshair.y -= 1
    crosshair_moved = true
  elseif btn(btn_down) then
    props.crosshair.y += 1
    crosshair_moved = true
  end

  if crosshair_moved then
    props.destination_star = get_destination_star(props.stars, props.crosshair)
  end

  return props
end

function starmap.draw(props)
  cls()
  
  circfill(props.player_pos.x, props.player_pos.y, props.player_range, dark_blue)

  if props.destination_star then

    if dist(props.player_pos, props.destination_star.pos) > props.player_range then   
      line(props.player_pos.x, props.player_pos.y, props.destination_star.pos.x, props.destination_star.pos.y, dark_blue)
      local dir = vec.norm(vec.sub(props.destination_star.pos, props.player_pos))
      local edge = vec.add(props.player_pos, vec.mul(dir, props.player_range))
      line(props.player_pos.x, props.player_pos.y, edge.x, edge.y, blue)
    else
      line(props.player_pos.x, props.player_pos.y, props.destination_star.pos.x, props.destination_star.pos.y, blue)
    end
  end
  
  for n,star in pairs(props.stars) do
    local star = props.stars[n]
    draw_star({
      star=star,
      player_pos=props.player_pos,
      player_range=props.player_range,
    })
  end

  spr(sprites.current_indicator, props.player_pos.x-3, props.player_pos.y-9)

  if props.crosshair.visible then
    spr(sprites.crosshair, props.crosshair.x-3, props.crosshair.y-3)
  end

  if props.destination_star then
    local ind
    
    if dist(props.player_pos, props.destination_star.pos) > props.player_range then
      ind = sprites.destination_indicator
    else
      ind = sprites.destination_indicator-1
    end 

    spr(ind, props.destination_star.pos.x-3, props.destination_star.pos.y-9)
  end
end

return starmap