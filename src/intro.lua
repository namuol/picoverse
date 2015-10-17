intro = {}

function intro.init(props)
  props.color = props.color or orange
  props.x = props.x or 0
  props.y = props.y or 0
  props._x = props.x
  props._y = props.y
  return props
end

function intro.update(props)
  props.color = props.color + 1 % 16
  
  if (rnd(1) < 0.02) then
    props.x = rnd(128)
    props.y = rnd(128)
  end

  props._x += (props.x - props._x) * 0.1
  props._y += (props.y - props._y) * 0.1

  return props
end

function intro.draw(props)
  cls()
  color(props.color)
  print(props.text, props._x, props._y)
end

return intro