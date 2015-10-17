function init(props)
  props.text = props.text or 'wacky'
  props.color = props.color or rnd(16)
  props.x = props.x or rnd(128)
  props.y = props.y or rnd(128)
  props._x = props.x
  props._y = props.y
  return {
    props=props,
    init=init,
    update=update,
    draw=draw
  }
end

function update(props)
  props.color = props.color + 1 % 16
  
  if (rnd(1) < 0.02) then
    props.x = rnd(128)
    props.y = rnd(128)
  end

  props._x += (props.x - props._x) * 0.1
  props._y += (props.y - props._y) * 0.1

  return props
end

function draw(props)
  color(props.color)
  print(props.text, props._x, props._y)
end

return {
  init=init,
  draw=draw,
  update=update,
}