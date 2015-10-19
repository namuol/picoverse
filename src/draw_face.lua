local skintones = {
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

local hairtones = {
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
  blue,
  -- green,
  dark_green,
  -- red,
}

function random_face_props()
  local skintone_idx = flr(rnd(#skintones))
  local skintone = skintones[1 + skintone_idx]

  local hairtone = skintone
  
  while hairtone == skintone do
    hairtone = hairtones[1 + flr(rnd(#hairtones))]
  end

  local hair
  if rnd(1) < 0.9 then
    hair = sprites.hair + flr(rnd(sprites.facial_hair - sprites.hair))
  end

  local facial_hair
  if rnd(1) < 0.25 then
    facial_hair = sprites.facial_hair + flr(rnd(4))
  end

  return {
    skintone=skintone,
    hairtone=hairtone,
    hair=hair,
    facial_hair=facial_hair,
  }
end

function draw_face(props,x,y)
  if not props then
    props = random_face_props()
  end

  pal(red, props.skintone)
  spr(sprites.face, x, y)

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