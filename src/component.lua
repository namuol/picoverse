function update(c)
  c.props = c.funcs.update(c.props)
end

function draw(c)
  c.funcs.draw(c.props)
end

function create(init,update,draw)
  return {
    init=init,
    update=update,
    draw=draw,
  }
end

return {
  create=create,
  update=update,
  draw=draw,
}