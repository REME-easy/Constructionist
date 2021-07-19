local map = require "src.level.map"

local block = {
  postfix = 0
}

block.new = function(data)
  local tmp = {
    name = data.name or "[MISSING]",
    type = data.type or "block",
    uuid = 0,
    color = {r = 1, g = 1, b = 1, a = 1},
    img = "block",
    icon = nil,
    parent_map = data.parent_map or 1,
    parent_group = data.parent_group or "map",
    child_map = data.child_map or -1,
    is_inspected = false,
    cx = 0,
    cy = 0,
    rot = 0,
    mx = 0,
    my = 0,
    size = 0.5,
    dir = data.dir or "up",
    can_win = data.can_win or false,
    can_move = data.can_move or false,
    can_pass = data.can_pass or false,
    can_push = data.can_push or false,
    is_static = data.is_static or false,
    is_insulated = data.is_insulated or false,
    triggers = {
      process = {},
      signal = {
        move = function(self, event)
          local dir = event.dir
          if self.can_move then
            if dir == "up" or dir == "down" or dir == "left" or dir == "right" then
              Gam:get_level():add_bot_action(
                function()
                  self:try_move(dir)
                end
              )
            end
          end
          return event
        end
      },
      collide = {}
    },
    current = {},
    update = function(self, dt)
    end,
    --
    draw = function(self, cx, cy)
      local x = cx and self.cx + cx or self.cx
      local y = cy and self.cy + cy or self.cy
      love.graphics.draw(Ast.images[self.img], x, y, self.rot, self.size, self.size)
      if self.icon then
        love.graphics.draw(Ast.images[self.icon], x, y, self.rot, self.size, self.size)
      end
      love.graphics.print(string.format("(%d,%d)\n%d", self.mx, self.my, self.uuid), x, y)
    end,
    --
    get_parent = function(self)
      return Gam:get_screen(self.parent_map)
    end,
    --
    get_parent_block = function(self)
      return Gam:get_screen(self.parent_map).parent
    end,
    --
    move = function(self, dir)
      self:get_parent():move_block(self.mx, self.my, dir, "map")
      return dir
    end,
    --
    is_moveable = function(self, dir)
      local parent = self:get_parent_block()
      local map = self:get_parent():get_map()
      local target = Hep.add_dir_v(self.mx, self.my, dir)
      if map:valid_cell(target) and map:empty_cell(target) then
        return true
      elseif not map:valid_cell(target) and parent then
        parent:try_move(dir)
        return false
      else
        local tmp = map:get_cell(target)
        if tmp then
          local event = tmp:on_collide({source = self, dir = dir})
          if not tmp.is_static and tmp.can_push and tmp:is_moveable(dir) then
            tmp:move(dir)
            return true
          end
        end
        return false
      end
    end,
    --
    try_move = function(self, dir)
      if not self.is_static and self:is_moveable(dir) then
        self:move(dir)
      end
    end,
    --
    on_process = function(self, event)
      for _, v in pairs(self.triggers.process) do
        event = v(self, event)
      end
      return event
    end,
    --
    on_signal = function(self, event)
      for _, v in pairs(self.triggers.signal) do
        event = v(self, event)
      end
      return event
    end,
    --
    on_collide = function(self, event)
      for _, v in pairs(self.triggers.collide) do
        event = v(self, event)
      end
      return event
    end,
    --
    process_current = function(self)
      if not self.is_insulated then
        local screen = self:get_parent()
      end
    end,
    --
    add_current = function(self, amt, dir)
      local flip = Hep.flip_dir(dir)
      local current = self.current
      if not current[dir] then
        current[dir] = 0
      end
      if current[flip] then
        self:add_current(-amt, flip)
      else
        current[dir] = current[dir] + amt
        if current[dir] == 0 then
          current[dir] = nil
        elseif current[dir] <= 0 then
          current[dir] = nil
          self:add_current(-amt, flip)
        end
      end
    end,
    --
    add_trigger = function(self, group, id, trigger)
      self.triggers[group][id] = trigger
    end
  }
  tmp.uuid = block.postfix
  block.postfix = block.postfix + 1
  setmetatable(
    tmp,
    {
      __eq = function(a, b)
        if b.uuid then
          return a.uuid == b.uuid
        end
        return false
      end,
      __tostring = function(self)
        return string.format("Block[%d]", self.uuid)
      end
    }
  )
  return tmp
end

return block
