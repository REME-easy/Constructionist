local block = require "src.objects.block"

local energy_cube = {}

energy_cube.new = function(data)
  local tmp = block.new(data)
  tmp.img = "energy_cube"
  tmp.type = "energy_cube"
  tmp.can_push = true
  tmp:add_trigger(
    "process",
    "process_energy",
    function(self, event)
      local _,
        j = self:get_parent():block_any_around(self)
      self:produce_current()
    end
  )

  return tmp
end

return energy_cube
