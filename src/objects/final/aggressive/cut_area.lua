local block = require "src.objects.block"

local cut_area = {}

cut_area.new = function(data)
  local tmp = block.new(data)
  tmp.img = "energy_cube"
  tmp.type = "energy_cube"
  tmp.can_push = true
  tmp:add_trigger(
    "process",
    "process_energy",
    function(self, event)
      self:produce_current()
    end
  )

  return tmp
end

return cut_area
