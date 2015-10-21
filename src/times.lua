return function(n, func)
  local ret = {}
  for i=0,n do
    add(ret, func())
  end
  return ret
end
