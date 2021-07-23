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
    child_map = data.child_map,
    is_inspected = false,
    cx = 0,
    cy = 0,
    rot = 0,
    mx = 0,
    my = 0,
    size = 0.5,
    current = 0,
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
        clear = function(self, event)
          if event.type == "clear" then
            self.current = 0
          end
          return event
        end,
        move = function(self, event)
          if event.type == "move" then
            local dir = event.dir
            if self.can_move then
              if dir == "up" or dir == "down" or dir == "left" or dir == "right" then
                self:try_move(dir)
              end
            end
          end
          return event
        end
      },
      collide = {}
    },
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
      love.graphics.print(string.format("(%d,%d)\n%d", self.mx, self.my, self.current), x, y)
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
      if self.child_map then
        Gam:get_screen(self.child_map):on_process(event)
      end
      for _, v in pairs(self.triggers.process) do
        event = v(self, event)
      end
      return event
    end,
    --
    on_signal = function(self, event)
      if self.child_map then
        Gam:get_screen(self.child_map):on_signal(event)
      end
      for _, v in pairs(self.triggers.signal) do
        event = v(self, event)
      end
      return event
    end,
    --
    on_collide = function(self, event)
      if self.child_map then
        Log(string.format("%s collide %s", self.uuid, event.source.uuid))
        if self.child_map == self.parent_map then
          Log(string.format("block[%d] is loop reference!", self.uuid))
          return event
        end
        Gam:get_screen(self.child_map):on_collide(event)
      end
      for _, v in pairs(self.triggers.collide) do
        event = v(self, event)
      end
      return event
    end,
    --
    produce_current = function(self)
      local around = self:get_parent():get_around_block(self)
      for d, b in pairs(around) do
        b:process_current(d, {self.uuid})
      end
    end,
    --
    process_current = function(self, dir, pass)
      if self.is_insulated then
        return
      end
      for _, v in ipairs(pass) do
        if v == self.uuid then
          return
        end
      end
      local event = self:on_signal({type = "current"})
      if event.stop then
        return
      end
      self.current = self.current + 1
      table.insert(pass, self.uuid)
      if self.current > 15 then
        return
      end
      for _, v in ipairs(Hep.except_dir(Hep.flip_dir(dir))) do
        local target = self:get_parent():get_dir_block(self, v)
        if target and target.uuid then
          target:process_current(v, pass)
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
