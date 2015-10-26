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

starmap = require('starmap')
faces = require('faces_test')
planetmap = require('planetmap')


mode_idx = 0

modes = {
  starmap,
  planetmap,
  faces,  
}

function _update()
  __current_props__ = __current_mode__.update(__current_props__)
  if btnp(btn_a,1) then
    mode_idx = (mode_idx + 1) % #modes
    set_mode(modes[1 + mode_idx])
  end
end

function _draw()
  __current_mode__.draw(__current_props__)
end


function _init()
  mode_idx = 0
  set_mode(modes[1 + mode_idx])
end
