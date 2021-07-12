local block = require "src.objects.block"

local mover = {}

mover.new = function(data)
  local tmp = block.new(data)
  tmp.icon = "move"
  tmp.img = "block"
  tmp.type = "mover"
  tmp.can_move = true
  tmp.can_push = true

  return tmp
end

return mover
