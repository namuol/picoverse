local dither_radius_map = require('dither_radius_map')

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

function random_star_props()
  local new_star = {
    pos={x=rnd(128),y=rnd(128)},
    visited=rnd(1)<0.05,
    mission=rnd(1)<0.01,
  }

  return new_star
end

local indicator_tweener = make_tweener({x=0.5,y=0.5})

function random_starmap_props()
  local stars = times(80, random_star_props)
  local current_star = stars[1+flr(rnd(#stars))]
  current_star.visited = true
  local props = {
    player_pos=current_star.pos,
    player_range=20 + rnd(80),
    stars=stars,
    indicator_pos={x=current_star.pos.x,y=current_star.pos.y},
    crosshair={
      visible=true,
      x=current_star.pos.x,
      y=current_star.pos.y,
    },
    crosshair_speed=0.5,
  }

  indicator_tweener.init(props.indicator_pos)

  return props
end

function starmap.init(props)
  props = props or random_starmap_props()
  props.fader = make_palette_fader(300)
  
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
    props.indicator_pos.tweens.targets.x = props.destination_star.pos.x
    props.indicator_pos.tweens.targets.y = props.destination_star.pos.y

    if props.crosshair_held_time > 10 then
      props.crosshair_speed = 2
    elseif props.crosshair_held_time > 5 then
      props.crosshair_speed = 1
    end
  end

  props.indicator_pos.tweens.tween(props.indicator_pos)

  return props
end

function starmap.draw(props)
  cls()
  pal()
  props.fader.update()
  
  -- dither_radius_map({
  --   radius=props.player_range,
  --   penumbra=16,
  --   pos=props.player_pos,
  -- })
  -- pal(red, dark_blue)
  -- map(0,0, 0,0, 16,16)
  -- pal()
  circfill(props.player_pos.x, props.player_pos.y, props.player_range, dark_blue)

  if props.destination_star then

    if dist(props.player_pos, props.destination_star.pos) > props.player_range then   
      line(props.player_pos.x, props.player_pos.y, props.indicator_pos.x, props.indicator_pos.y, dark_blue)
      local pos = {x=props.indicator_pos.x,y=props.indicator_pos.y}
      local dir = vec.norm(vec.sub(pos, props.player_pos))
      local edge = vec.add(props.player_pos, vec.mul(dir, props.player_range))
      line(props.player_pos.x, props.player_pos.y, edge.x, edge.y, blue)
    else
      line(props.player_pos.x, props.player_pos.y, props.indicator_pos.x, props.indicator_pos.y, blue)
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
      pal(dark_blue, black)
      pal(black, dark_blue)
      palt(black, true)
      palt(dark_blue, false)
    else
      ind = sprites.destination_indicator
    end

    spr(ind, props.indicator_pos.x-3, props.indicator_pos.y-9)
    pal(dark_blue, dark_blue)
    pal(black, black)
    palt()
  end
end

return starmap