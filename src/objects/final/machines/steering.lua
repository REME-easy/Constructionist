local block = require "src.objects.block"

local steering = {}

steering.new = function(data)
  local tmp = block.new(data)
  tmp.icon = "move"
  tmp.img = "block"
  tmp.type = "steering"
  tmp:add_trigger(
    "process",
    "steering",
    function(self, event)
    end
  )

  return tmp
end

return steering
