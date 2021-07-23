local block = require "src.objects.block"

local receiver = {}

receiver.new = function(data)
  local tmp = block.new(data)
  tmp.img = "receiver"
  tmp.type = "receiver"
  tmp:add_trigger(
    "signal",
    "receive",
    function(self, event)
      if event.type == "signal" then
        if event.signal == self.signal then
          self:produce_current()
        end
      end
      return event
    end
  )

  return tmp
end

return receiver
