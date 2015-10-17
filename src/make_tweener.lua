return function(amts)
  local tweener = {}

  function tweener.init(props)
    -- initialize default vals
    for p,amt in pairs(amts) do
      props['_'..p] = props[p]
    end
  end

  function tweener.tween(props)
    for p,amt in pairs(amts) do
      local _p = '_'..p
      local v = props[_p]
      props[_p] += (props[p] - v) * amt
    end
  end

  return tweener
end
