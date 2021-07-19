local block = require "src.objects.block"

local wall = {}

wall.new = function(data)
  local tmp = block.new(data)
  tmp.type = "wall"
  tmp.img = "wall"
  tmp.is_static = true

  return tmp
end

return wall
