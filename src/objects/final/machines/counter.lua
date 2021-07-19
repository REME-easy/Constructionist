local block = require "src.objects.block"

local counter = {}

counter.new = function(data)
  local tmp = block.new(data)
  tmp.img = "button"
  tmp.type = "counter"
  tmp.can_win = true
  tmp.can_move = true
  tmp.can_push = true
  tmp.count = data.count or 0

  return tmp
end

return counter
