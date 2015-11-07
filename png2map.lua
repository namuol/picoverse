#!/usr/bin/luajit

local magick = require "magick"

_rgb_colors = {
  ["0,0,0"] = 0,
  ["29,43,83"] = 1,
  ["126,37,83"] = 2,
  ["0,135,81"] = 3,
  ["171,82,54"] = 4,
  ["95,87,79"] = 5,
  ["194,195,199"] = 6,
  ["255,241,232"] = 7,
  ["255,0,77"] = 8,
  ["255,163,0"] = 9,
  ["255,240,36"] = 10,
  ["0,231,86"] = 11,
  ["41,173,255"] = 12,
  ["131,118,156"] = 13,
  ["255,119,168"] = 14,
  ["255,204,170"] = 15,
}

function rgb2pico(r,g,b)
  return _rgb_colors[r..","..g..","..b]
end

if not arg[1] or not arg[2] then

  print("Usage:\tpng2map.lua [FILE.png] [TARGET.p8]")
  print("Replaces the __map__ section of the TARGET with the contents of FILE and then\nprints it to stdout.")
  print("e.g.: ./png2map.lua map.png cart.p8 > new_cart.p8")

else

  local png_file,png_file_error = magick.load_image(arg[1])
  assert(png_file,png_file_error)
  local target_file = io.open(arg[2])

  local found_map = false
  local map_done = false
  while true do
    local target_line = target_file:read("*line")

    if target_line == nil then break end

    for section,_ in string.gmatch(target_line,"__(%a+)__") do
      if section == "map" then
        found_map = true
        break
      else
        found_map = false
        break
      end
    end

    if not found_map then
      io.write(target_line.."\n")
    elseif not map_done then
      map_done = true
      io.write("__map__\n")
      for y = 0,31 do
        for x = 0,127 do
          local r,g,b,a = png_file:get_pixel(x,y)
          if a >= 1.0 then
            -- We assume greyscale image, and only look at the red pixel value:
            io.write(string.format("%02x", math.floor(r*255)))
          else
            -- If the alpha channel is < 1.0, we treat it as a colormap:
            local pico_color = rgb2pico(
              math.floor(r*255),
              math.floor(g*255),
              math.floor(b*255))
            assert(pico_color,"Error: Input image contains invalid color")
            io.write(string.format("%02x",pico_color))
          end
        end
        io.write("\n")
      end
      io.write("\n")
    end

  end

end
