local block = require "src.objects.block"

local rebot = {}

rebot.new = function(data)
  local tmp = block.new(data)
  tmp.type = "rebot"
  tmp.img = "block"
  tmp.can_move = false
  tmp.can_push = false

  return tmp
end

return rebot
