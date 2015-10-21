return function(amts, props)
  local tweener = {}
  tweener.vals = {}

  -- initialize default vals
  for p,amt in pairs(amts) do
    tweener.vals[p] = props[p]
  end

  function tweener.tween(props)
    for p,amt in pairs(amts) do
      local v = tweener.vals[p]
      tweener.vals[p] += (props[p] - v) * amt
    end
  end

  return tweener
end
