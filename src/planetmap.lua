local dist = require('dist')
local vec = require('vec')
local make_tweener = require('make_tweener')
local clamp = require('clamp')
local times = require('times')
local choose = require('choose')

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

function random_moon_props()
  return {
    size=choose(moon_size_probs),
    color=choose(moon_color_probs),
  }
end

function random_planet_props()
  return {
    color=choose(planet_color_probs),
    size=choose(planet_size_probs),
    moons=times(choose(moon_count_probs), random_moon_props),
  }
end

function random_planetmap_props()
  return {
    planets=times(choose(planet_count_probs), random_planet_props)
  }
end

function compute_drawables(props)
  drawables = {}
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
      end
      top += pad*2
    end

    drawable_planet = {
      planet=planet,
      moons={},
      x=left,
      y=top,
    }
    add(drawables, drawable_planet)

    left += planet.size + pad

    if selected and props.selected.moon == 0 then
      left += pad*2
    end

    for mp,moon in pairs(planet.moons) do
      left += moon.size
   
      if selected and props.selected.moon == mp then
        left += pad*2
        top += pad
      end
   
      drawable_moon = {
        planet=moon,
        x=left,
        y=top,
      }
      add(drawable_planet.moons, drawable_moon)
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

  return drawables
end

function planetmap.init(props)
  props = props or random_planetmap_props()
  local planet = choose(props.planets)
  props.selected = {
    planet=1+flr(rnd(#props.planets)),
    moon=flr(rnd(#planet.moons + 1)),
  }
  props.drawables = compute_drawables(props)
  props.tweens = {}
  for n,dp in pairs(props.drawables) do
    local dptw = {
      tw=make_tweener({x=0.4,y=0.4}, dp),
      moons={},
    }
    add(props.tweens, dptw)
    
    for n,dm in pairs(dp.moons) do
      local dmtw = {
        tw=make_tweener({x=0.4-0.06*n,y=0.4-0.06*n}, dm),
      }
      add(dptw.moons, dmtw)
    end
  end
  return props
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
    props.drawables = compute_drawables(props)
  end

  for np,dptw in pairs(props.tweens) do
    local dp = props.drawables[np]
    dptw.tw.tween(dp)
    for nm,dmtw in pairs(dptw.moons) do
      local dm = dp.moons[nm]
      dmtw.tw.tween(dm)
    end
  end

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
  for np,dp in pairs(props.drawables) do
    local dptw = props.tweens[np]
    draw_planet(dp.planet, dptw.tw.vals.x, dptw.tw.vals.y, props.selected.planet == np and props.selected.moon == 0)
    for nm,dm in pairs(dp.moons) do
      local dmtw = dptw.moons[nm]
      draw_planet(dm.planet, dmtw.tw.vals.x, dmtw.tw.vals.y, props.selected.planet == np and props.selected.moon == nm)
    end
  end
end

return planetmap