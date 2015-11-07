function make_printer(
 xfn,
 yfn,
 cfn,
 n
)
  n = n or 120

  local t = 0

  return {
    update = function()
      t += 1/n
    end,

    draw = function(text,ix,iy)
      for i=1, #text do
        local ch = sub(text,i,i)
        if ch != ' ' then
          x = ix + i*4 + xfn(t,i)
          y = iy + yfn(t,i)
          color(cfn(t,i))
          print(ch,x,y)
          end
      end
    end
  }
end

return make_printer