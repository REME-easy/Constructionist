local block = require "src.objects.block"

local robot = {}

robot.new = function(data)
  local tmp = block.new(data)
  tmp.type = "robot"
  tmp.img = "block"
  tmp.can_win = true

  return tmp
end

return robot
