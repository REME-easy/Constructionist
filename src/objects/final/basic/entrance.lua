local block = require "src.objects.block"

local entrance = {}

entrance.new = function(data)
  local tmp = block.new(data)
  tmp.img = "entrance"
  tmp.type = "entrance"
  tmp:add_trigger(
    "collide",
    "enter",
    function(self, event)
      local source = event.source
      local parent = self:get_parent_block()
      local map = self:get_parent()
      local size = map.map_size
      local dir = false
      if self.mx ~= self.my and self.mx ~= -self.my then
        if self.mx == 1 then
          dir = "left"
        elseif self.mx == size.x then
          dir = "right"
        end
        if self.my == 1 then
          dir = "up"
        elseif self.my == size.y then
          dir = "down"
        end
      end
      if parent and dir then
        local p_map = Gam:get_screen(parent.parent_map)
        if source.parent_map == self.parent_map and dir == event.dir then
          Log(tostring(self.uuid) .. ":parent to child")
          local tar_pos = Hep.add_dir_v(parent.mx, parent.my, dir)
          if not p_map:get_map():exist_cell(tar_pos) then
            map:remove_block(source.mx, source.my, source.parent_group)
            p_map:add_block(tar_pos.x, tar_pos.y, source)
          end
        elseif source.parent_map ~= self.parent_map and Hep.flip_dir(dir) == event.dir then
          Log(tostring(self.uuid) .. ":child to parent")
          local tar_pos = Hep.add_dir_v(self.mx, self.my, Hep.flip_dir(dir))
          if not map:get_map():exist_cell(tar_pos) then
            p_map:remove_block(source.mx, source.my, source.parent_group)
            map:add_block(tar_pos.x, tar_pos.y, source)
          end
        end
      end
      return event
    end
  )

  return tmp
end

return entrance
