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
end

function _draw()
  __current_mode__.draw(__current_props__)
end

intro = require('intro')

-- end game mode

function _init()
 set_mode(intro, {text='hello', x=20})
end
