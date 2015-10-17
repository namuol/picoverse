component = require('component')
make_tweener = require('make_tweener')

funcs = nil

tweener = make_tweener({x=0.1, y=0.1})

function init(props)
  props.text = props.text or 'wacky'
  props.color = props.color or rnd(16)
  props.x = props.x or rnd(128)
  props.y = props.y or rnd(128)
  
  tweener.init(props)

  return {
    props=props,
    funcs=funcs,
  }
end

function update(props)
  props.color = props.color + 1 % 16
  
  if (rnd(1) < 0.02) then
    props.x = rnd(128)
    props.y = rnd(128)
  end

  tweener.tween(props)

  return props
end

function draw(props)
  color(props.color)
  print(props.text, props._x, props._y)
end

funcs = component.create(init,update,draw)

return funcs