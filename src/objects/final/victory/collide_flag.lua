local block = require "src.objects.block"

local collide_flag = {}

collide_flag.new = function(data)
  local tmp = block.new(data)
  tmp.icon = "collide"
  tmp.img = "flag"
  tmp.type = "flag"
  tmp:add_trigger(
    "collide",
    "collide_to_win",
    function(self, event)
      local source = event.source
      if source and source.can_win then
        Gam:get_level():win()
      end
    end
  )
  return tmp
end

return collide_flag
