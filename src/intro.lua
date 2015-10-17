component = require('component')
wackytext = require('wackytext')

intro = {}

function intro.init(props)
  props.children = props.children or {
    wackytext.init({text='test1'}),
    wackytext.init({text='test2'}),
    wackytext.init({text='test3'}),
  }

  return props
end

function intro.update(props)
  foreach(props.children, component.update)

  return props
end

function intro.draw(props)
  cls()
  foreach(props.children, component.draw)
end

return intro