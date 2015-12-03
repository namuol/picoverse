local world = nil

local planetmap = {}

local planet_count_probs = {
  1,1,
  2,2,2,
  3,3,3,3,
  4,4,4,
  5,5,
  6,6
}

local planet_color_probs = {
  -- light_gray,
  -- light_gray,
  -- light_gray,
  light_gray,

  -- brown,
  -- brown,

  -- dark_gray,
  -- dark_gray,
  -- dark_gray,

  -- dark_green,
  -- dark_green,

  -- dark_purple,
  pink,  
  green,
  orange,
  blue,
  -- dark_blue,
}

local planet_size_probs = {
  3,3,3,
  5,5,5,5,5,5,

  -- 6,6,6,6,6,6,
  7,7,7
}

local moon_count_probs = {
  0,0,0,0,
  1,1,1,1,1,
  2,2,2,2,2,2,
  3,3,3,3,
  4,4,
}

local moon_color_probs = {
  light_gray,
  light_gray,

  brown,
  brown,
  brown,
  brown,

  dark_gray,
  dark_gray,
  dark_gray,
  dark_gray,
  dark_gray,
  dark_gray,

  dark_green,
  dark_green,
  dark_green,

  dark_blue,
  dark_blue,
  dark_blue,
  dark_blue,
  dark_blue,
  dark_blue,
}

local moon_size_probs = {
  1,1,1,1,1,1,1,1,
  2,2,2,2,2,2,2,2,2,2,
  -- 3,3,3,
}

local tweener = make_tweener({x=0.4,y=0.4})

function random_moon_props()
  local props = {
    size=choose(moon_size_probs),
    color=choose(moon_color_probs),
    draw=draw_planet,
    x=0,y=0,
  }

  tweener.init(props)

  return props
end

function random_planet_props()
  local props = {
    color=choose(planet_color_probs),
    size=choose(planet_size_probs),
    moons=times(choose(moon_count_probs), random_moon_props),
    draw=draw_planet,
    x=0,y=0,
  }

  tweener.init(props)

  return props
end

function random_planetmap_props()
  return {
    planets=times(choose(planet_count_probs), random_planet_props)
  }
end

function update_tween_positions(props)
  local pad = 3
  local top = 1

  for np,planet in pairs(props.planets) do
    top += planet.size
    local left = 7
    local selected

    if props.selected.planet == np then
      selected = true
      if props.selected.moon == 0 then
        left += pad*2
        planet.selected = true
      else
        planet.selected = false
      end
      top += pad*2
    else
      planet.selected = false
    end
    
    planet.tweens.targets.x = left
    planet.tweens.targets.y = top

    left += planet.size + pad

    if selected and props.selected.moon == 0 then
      left += pad*2
    end

    for mp,moon in pairs(planet.moons) do
      left += moon.size
      moon.tweens.factor = 1/(1 + mp*0.25)
   
      if selected and props.selected.moon == mp then
        left += pad*2
        top += pad
        moon.selected = true
      else
        moon.selected = false
      end
   
      moon.tweens.targets.x = left
      moon.tweens.targets.y = top

      left += moon.size + pad

      if selected and props.selected.moon == mp then
        left += pad*2
        top -= pad
      end
    end

    top += planet.size + pad

    if selected then
      top += pad*2
    end
  end
end

function planetmap.init(props)
  props = props or random_planetmap_props()
  local planet = choose(props.planets)
  props.selected = {
    planet=1+flr(rnd(#props.planets)),
    moon=flr(rnd(#planet.moons + 1)),
  }

  world = ecs.world()

  for np,planet in pairs(props.planets) do
    world.addEntity(planet)
    for nm,moon in pairs(planet.moons) do
      world.addEntity(moon)
    end
  end

  update_tween_positions(props)

  props.fader = make_palette_fader(300)
  return props
end

function tween(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"tweens"})) do
    entity.tweens.tween(entity)
  end

  return entities
end

function draw(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"draw"})) do
    entity.draw(entity, entity.x, entity.y, entity.selected)
  end

  return entities
end

function planetmap.update(props)
  if btnp(btn_a) then
    return planetmap.init()
  end

  local dirty = false
  if btnp(btn_down) then
    props.selected.planet = 1 + (props.selected.planet % #props.planets)
    props.selected.moon = 0
    dirty = true
  elseif btnp(btn_up) then
    props.selected.planet = 1 + ((props.selected.planet-2) % #props.planets)
    props.selected.moon = 0
    dirty = true
  end
  local selected_planet = props.planets[props.selected.planet]
  if btnp(btn_right) then
    props.selected.moon = (props.selected.moon+1) % (#selected_planet.moons + 1)
    dirty = true
  elseif btnp(btn_left) then
    props.selected.moon = (props.selected.moon-1) % (#selected_planet.moons + 1)
    dirty = true
  end

  if dirty then
    update_tween_positions(props)
  end

  world.invoke({
    tween,
  })

  return props
end

function draw_planet(props,x,y,selected)
  if selected then
    circ(x, y, props.size+2, red)
    rectfill(x-props.size-2,y-props.size-2,x+props.size+2, y+flr(props.size/2), black)
  end
  circfill(x, y, props.size, props.color)
end

function planetmap.draw(props)
  cls()
  pal()

  props.fader.update()
  
  world.invoke({
    draw,
  })
end

return planetmap