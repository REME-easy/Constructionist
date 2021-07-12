local block = require "src.objects.block"

local box = {}

box.new = function(data)
  local tmp = block.new(data)
  tmp.img = "box"
  tmp.can_move = false
  tmp.can_push = true

  return tmp
end

return box
