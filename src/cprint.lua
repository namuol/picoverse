function cprint (str, y, col)
  local x = (127 - #str*4) / 2
  if (col) then
    print(str, x, y, col)
  else
    print(str, x, y)
  end
end

return cprint