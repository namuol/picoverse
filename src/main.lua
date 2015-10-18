-- color constants

black = 0
dark_blue = 1
dark_purple = 2
dark_green = 3
brown = 4
dark_gray = 5
light_gray = 6
white = 7
red = 8
orange = 9
yellow = 10
green = 11
blue = 12
indigo = 13
pink = 14
peach = 15

-- boilerplate

__current_mode__ = nil
__current_props__ = nil

function set_mode(mode, initial_props)
  __current_mode__ = mode
  __current_props__ = mode.init(initial_props)
end

function _update()
  __current_props__ = __current_mode__.update(__current_props__)

  if btnp(4) then
    do_random_starmap()
  end
end

function _draw()
  __current_mode__.draw(__current_props__)
end

intro = require('intro')
starmap = require('starmap')

-- end game mode

function random_star()
  local new_star = {
    pos={x=rnd(128),y=rnd(128)}
  }

  return new_star
end

function times(n, func)
  local ret = {}
  for i=0,n do
    add(ret, func())
  end
  return ret
end

function do_random_starmap()
  local stars = times(80, random_star)
  set_mode(starmap, {
    player_pos=stars[1+flr(rnd(#stars))].pos,
    player_range=5 + rnd(40),
    stars=stars
  })
end

function _init()
  do_random_starmap()
end
