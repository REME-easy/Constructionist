local block = require "src.objects.block"

local publisher = {}

publisher.new = function(data)
  local tmp = block.new(data)
  tmp.icon = "collide"
  tmp.img = "publisher"
  tmp.type = "collide_publisher"
  tmp.published = false
  tmp.signal = data.signal
  tmp:add_trigger(
    "process",
    "collide_publish",
    function(self, event)
      if self.signal then
        local any = self:get_parent():block_any_around(self)
        if any and not self.published then
          self.published = true
          self.get_parent():publish_signal({type = "signal", signal = self.signal})
        elseif not any and self.published then
          self.published = false
        end
      end
      return event
    end
  )

  return tmp
end

return publisher
