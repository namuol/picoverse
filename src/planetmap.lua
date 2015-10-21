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
  light_gray,
  light_gray,
  light_gray,
  light_gray,

  brown,
  brown,

  dark_gray,
  dark_gray,
  dark_gray,

  dark_green,
  dark_green,

  dark_purple,
  pink,  
  green,
  orange,
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
  2,2,2,
  3,3,
}

local moon_color_probs = {
  light_gray,
  light_gray,
  light_gray,
  light_gray,
  light_gray,
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

  dark_green,
  dark_green,

  green,
  green,
  green,
  green,
  green,
  blue,
  blue,
  blue,
  blue,
  blue,
  blue,
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

function planetmap.init(props)
  props = props or random_planetmap_props()
  return props
end

function planetmap.update(props)
  return props
end

function draw_planet(props,x,y)
  -- printh(x)
  -- printh(y)
  -- printh(props.size)
  -- printh(props.color)
  circfill(x, y, props.size, props.color)
  -- circfill(x, y, 4, pink)
end

function planetmap.draw(props)
  cls()
  local top = 1
  for n,planet in pairs(props.planets) do
    top += planet.size
    draw_planet(planet, 7, top)
    local left = 3 + planet.size
    for m,moon in pairs(planet.moons) do
      left += moon.size
      draw_planet(moon, 7 + left, top)
      left += moon.size + 3
    end
    top += planet.size + 3
  end
end

return planetmap