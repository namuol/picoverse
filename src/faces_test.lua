local draw_face = require('draw_face')

function draw_random_faces()
  cls()
  pal()
  for n=0,14*14 - 1 do
    draw_face(nil, (n % 14)*9, flr(n/14)*9)
  end
end

local faces = {}

function faces.init(props)
  draw_random_faces()
  props = {
    redraw=false,
    fader=make_palette_fader(300)
  }
  return props
end

function faces.update(props)
  if btnp(4) then
    props.redraw = true
  else
    props.redraw = false
  end
  return props
end

function faces.draw(props)
  props.fader.update()

  if props.redraw then
    draw_random_faces()
  end
end

return faces