return function(amts)
  local tweener = {}

  function tweener.init(props, factor)
    props.tweens = {
      tween=tweener.tween,
      factor=factor or 1,
      targets={},
    }

    for p,amt in pairs(amts) do
      props.tweens.targets[p] = props[p]
    end
  end

  function tweener.tween(props)
    for p,amt in pairs(amts) do
      local target = props.tweens.targets[p]
      props[p] += (target - props[p]) * amt * props.tweens.factor
    end
  end

  return tweener
end
