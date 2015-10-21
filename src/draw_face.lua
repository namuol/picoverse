local choose = require('choose')

local face_probs = {
  80
}

local hair_probs = {
  0,
  81,
  81,
  81,
  82,
  82,
  82,
  83,
  83,
  83,
  84,
  84,
  84,
}

local facial_hair_probs = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  85,
  86,
  87,
  88,
}

local skintone_probs = {
  -- hooman colors:
  brown,
  brown,
  brown,
  peach,
  peach,
  peach,
  white,
  white,

  -- alium colors:
  indigo,
  blue,
  green,
  red,
}

local hairtone_probs = {
  -- orange,
  orange,
  -- yellow,
  yellow,
  -- white,
  white,
  -- brown,
  brown,
  -- light_gray,
  light_gray,
  -- dark_gray,
  dark_gray,

  dark_purple,
  dark_blue,
  blue,
  -- green,
  dark_green,
  -- red,
}

function random_face_props()
  local skintone = choose(skintone_probs)

  local hairtone = skintone
  while hairtone == skintone do
    hairtone = choose(hairtone_probs)
  end

  return {
    skintone=skintone,
    hairtone=hairtone,
    hair=choose(hair_probs),
    facial_hair=choose(facial_hair_probs),
    face=choose(face_probs)
  }
end

function draw_face(props,x,y)
  if not props then
    props = random_face_props()
  end

  pal(red, props.skintone)
  spr(props.face, x, y)

  if props.hair then
    pal(red, props.hairtone)
    spr(props.hair, x, y)
  end

  if props.facial_hair then
    pal(red, props.hairtone)
    spr(props.facial_hair, x, y)
  end

  pal(red, red)
end

return draw_face