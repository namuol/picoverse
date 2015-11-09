-- stolen from the jelpi demo <3

local dpal={0,1,1, 2,1,13,6,
            4,4,9,3, 13,1,13,14}
        
function make_palette_fader()
  local i = 30
  return {
    update = function()
      if i < 0 then
        return false
      end

      i -= 1

      for j=1,15 do
        col = j
        for k=1,((i+(j%5))/4) do
          col=dpal[col]
        end
        pal(j,col,1)
      end
      return true
    end,
    reset = function()
      i = 30
    end
  }
end

return make_palette_fader