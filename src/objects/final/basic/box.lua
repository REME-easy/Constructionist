local block = require "src.objects.block"

local box = {}

box.new = function(data)
  local tmp = block.new(data)
  tmp.img = "box"
  tmp.can_push = true
  tmp.is_insulated = false

  return tmp
end

return box
