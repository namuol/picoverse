function update(c)
  c.props = c.update(c.props)
end

function draw(c)
  c.draw(c.props)
end

return {
  update=update,
  draw=draw,
}