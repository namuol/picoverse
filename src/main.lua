require('colors')
require('sprites')
require('buttons')

-- boilerplate

__current_mode__ = nil
__current_props__ = nil

function set_mode(mode, initial_props)
  __current_mode__ = mode
  __current_props__ = mode.init(initial_props)
end

function _update()
  __current_props__ = __current_mode__.update(__current_props__)
end

function _draw()
  __current_mode__.draw(__current_props__)
end

starmap = require('starmap')
faces = require('faces_test')

-- end game mode

function random_star()
  local new_star = {
    pos={x=rnd(128),y=rnd(128)},
    visited=rnd(1)<0.05,
    mission=rnd(1)<0.01,
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

function _init()
  set_mode(starmap)
  -- do_random_starmap()
end
