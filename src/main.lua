printh('------------------------------------------------------')
printh(' picoverse by @lourobros')
printh(' source code available at github.com/namuol/picoverse')
printh('------------------------------------------------------')

require('colors')
require('sprites')
require('buttons')

__current_mode__ = nil
__current_props__ = nil

function set_mode(mode, initial_props)
  __current_mode__ = mode
  __current_props__ = mode.init(initial_props)
end

function _update()
  __current_props__ = __current_mode__.update(__current_props__)
  if btnp(btn_a,1) then
    printh(stat(0))
  end
end

function _draw()
  __current_mode__.draw(__current_props__)
end

starmap = require('starmap')
faces = require('faces_test')
planetmap = require('planetmap')

function _init()
  set_mode(planetmap)
end
