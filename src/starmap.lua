local dist = require('dist')
local vec = require('vec')
local make_tweener = require('make_tweener')
local clamp = require('clamp')
local times = require('times')

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

local starmap = {}

function random_starmap_props()
  local stars = times(80, random_star)
  local current_star = stars[1+flr(rnd(#stars))]
  current_star.visited = true
  return {
    player_pos=current_star.pos,
    player_range=20 + rnd(80),
    stars=stars,
    dest_indicator_pos={x=current_star.pos.x,y=current_star.pos.y},
    crosshair={
      visible=true,
      x=current_star.pos.x,
      y=current_star.pos.y,
    },
    crosshair_speed=0.5,
  }
end


function starmap.init(props)
  props = props or random_starmap_props()

  props.dest_indicator_pos_tween = make_tweener({x=0.4,y=0.4}, props.dest_indicator_pos)
  return props
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
  local crosshair_v = {x=0,y=0}

  if btn(btn_left) then
    crosshair_v.x = -1
    crosshair_moved = true
  elseif btn(btn_right) then
    crosshair_v.x = 1
    crosshair_moved = true
  end

  if btn(btn_up) then
    crosshair_v.y = -1
    crosshair_moved = true
  elseif btn(btn_down) then
    crosshair_v.y = 1
    crosshair_moved = true
  end

  crosshair_v = vec.mul(vec.norm(crosshair_v), props.crosshair_speed)
  props.crosshair.x = clamp(props.crosshair.x+crosshair_v.x, 0,127)
  props.crosshair.y = clamp(props.crosshair.y+crosshair_v.y, 0,127)

  if not crosshair_moved then
    props.crosshair_speed = 0.5
    props.crosshair_held_time = 0
  else
    props.destination_star = get_destination_star(props.stars, props.crosshair)
    props.crosshair_held_time += 1
    props.dest_indicator_pos = props.destination_star.pos

    if props.crosshair_held_time > 10 then
      props.crosshair_speed = 2
    elseif props.crosshair_held_time > 5 then
      props.crosshair_speed = 1
    end
  end

  props.dest_indicator_pos_tween.tween(props.dest_indicator_pos)
  return props
end

function starmap.draw(props)
  cls()
  
  circfill(props.player_pos.x, props.player_pos.y, props.player_range, dark_blue)

  if props.destination_star then

    if dist(props.player_pos, props.destination_star.pos) > props.player_range then   
      line(props.player_pos.x, props.player_pos.y, props.dest_indicator_pos_tween.vals.x, props.dest_indicator_pos_tween.vals.y, dark_blue)
      local pos = {x=props.dest_indicator_pos_tween.vals.x,y=props.dest_indicator_pos_tween.vals.y}
      local dir = vec.norm(vec.sub(pos, props.player_pos))
      local edge = vec.add(props.player_pos, vec.mul(dir, props.player_range))
      line(props.player_pos.x, props.player_pos.y, edge.x, edge.y, blue)
    else
      line(props.player_pos.x, props.player_pos.y, props.dest_indicator_pos_tween.vals.x, props.dest_indicator_pos_tween.vals.y, blue)
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

    spr(ind, props.dest_indicator_pos_tween.vals.x-3, props.dest_indicator_pos_tween.vals.y-9)
  end
end

return starmap