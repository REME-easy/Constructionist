local map = require "src.level.map"

local screen = {}

screen.new = function(self, data)
  local map_data = function(id)
    return {
      w = data.width,
      h = data.height,
      id = id
    }
  end

  local tmp = {
    groups = {
      data.ground or map:new(map_data("ground")),
      data.map or map:new(map_data("map")),
      data.ceiling or map:new(map_data("ceiling"))
    },
    can_draw = data.draw or false,
    cursor = nil,
    parent = nil,
    id = data.id or 1,
    cx = 0,
    cy = 0,
    size = {x = 1, y = 1},
    map_size = {x = data.width or 1, y = data.height or 1},
    cell_size = {x = 32, y = 32},
    --
    update = function(self, dt)
      for _, v in pairs(self.groups) do
        v:update(dt)
      end
    end,
    --
    draw = function(self)
      local width = self.map_size.x
      local height = self.map_size.y
      local cell = self.cell_size
      local x = self.cx
      local y = self.cy

      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("fill", x, y, width * cell.x, height * cell.y)
      love.graphics.setColor(0.5, 0.5, 0.5, 1)
      for _ = 1, height do
        x = self.cx
        for _ = 1, width do
          love.graphics.rectangle("line", x, y, cell.x, cell.y)
          x = x + cell.x
        end
        y = y + cell.y
      end
      love.graphics.setColor(1, 1, 1, 1)
      for _, v in pairs(self.groups) do
        v:draw(self.cx, self.cy)
      end
    end,
    --
    draw_debug = function(self)
      local map = self.map_size
      love.graphics.print(string.format("(%d,%d)\n[%d,%d]", self.cx, self.cy, map.x, map.y), self.cx - 50, self.cy)
    end,
    --
    resize = function(self, w, h)
    end,
    --
    to_center = function(self)
      local width = love.graphics.getWidth()
      local height = love.graphics.getHeight()
      local map = self.map_size
      local cell = self.cell_size

      self.cx = (width - map.x * cell.x) / 2
      self.cy = (height - map.y * cell.y) / 2
    end,
    --
    to_position = function(self, index)
      if index <= 0 then
        self:to_center()
      end
      local width = love.graphics.getWidth()

      self.cx = index <= 3 and 10 - self.size.x or width
      self.cy = 50 + 160 * ((index - 1) % 3)

      local tx = index <= 3 and 10 or width - self.size.x - 10

      Tw:add_tween(1, self, {cx = tx}, "inCubic")
    end,
    --
    get_map = function(self, group)
      if not group then
        return self.groups.map
      end
      return self.groups[group]
    end,
    --
    add_block = function(self, x, y, val, group)
      local g = self.groups[group or "map"]
      if g then
        val.parent_map = self.id
        val.parent_group = group or "map"
        self:set_block(x, y, val, false, group or "map", true)
      end
      return val
    end,
    --
    remove_block = function(self, x, y, group)
      local g = self.groups[group or "map"]
      if g then
        local val = g:get_cell(x, y)
        if not val or not val.uuid then
          return false
        end
        self:set_block(x, y, {}, false, group or "map", false)
        return true
      end
    end,
    --
    set_block = function(self, x, y, val, anim, group, add)
      if not self.groups[group] then
        return
      end
      local cell = self.cell_size

      local tx = (x - 1) * cell.x
      local ty = (y - 1) * cell.y

      if not anim then
        val.cx = tx
        val.cy = ty
      else
        Tw:add_tween(0.1, val, {cx = tx, cy = ty}, "inCubic")
      end

      val.mx = x
      val.my = y
      if add ~= nil then
        return self.groups[group]:set_cell(x, y, val, add)
      end
      return self.groups[group]:set_cell(x, y, val)
    end,
    --
    move_block = function(self, x, y, dir, group)
      if not self.groups[group] then
        return
      end
      local block = self.groups[group]:get_cell(x, y)
      if block then
        local tmp = Hep.add_dir_v(x, y, dir)
        if self.groups[group]:valid_cell(tmp.x, tmp.y) then
          self:set_block(tmp.x, tmp.y, block, true, group)
          self:set_block(x, y, {}, false, group)
        end
      end
    end,
    --
    add_screen_to_block = function(self, x, y, sc, group, not_add)
      local g = self.groups[group]
      if not g then
        return
      end
      local val = g:get_cell(x, y)
      if val.uuid and val.parent_map ~= #(Gam:get_level().screens) then
        if not not_add then
          Gam:get_level():add_screen_inst(sc)
        end
        sc.parent = val
        val.child_map = sc.id
      end
    end,
    --
    on_process = function(self, event)
      for i, v in pairs(self.groups) do
        for j, v2 in ipairs(v.objects) do
          Gam:get_level():add_bot_action(
            function()
              v2:on_process(event)
            end
          )
        end
      end
    end,
    --
    on_signal = function(self, event)
      for _, v in pairs(self.groups) do
        if event.type == "move" then
          local dir = event.dir
          local tmp = {}
          local sorter
          for _, obj in ipairs(v.objects) do
            table.insert(tmp, obj)
          end
          if dir == "up" then
            sorter = function(a, b)
              if a.my == b.my then
                return a.mx < b.mx
              end
              return a.my < b.my
            end
          elseif dir == "down" then
            sorter = function(a, b)
              if a.my == b.my then
                return a.mx < b.mx
              end
              return a.my > b.my
            end
          elseif dir == "left" then
            sorter = function(a, b)
              if a.mx == b.mx then
                return a.my < b.my
              end
              return a.mx < b.mx
            end
          elseif dir == "right" then
            sorter = function(a, b)
              if a.mx == b.mx then
                return a.my < b.my
              end
              return a.mx > b.mx
            end
          end
          table.sort(tmp, sorter)
          for _, v2 in ipairs(tmp) do
            Gam:get_level():add_bot_action(
              function()
                v2:on_signal(event)
              end
            )
          end
        else
          for _, v2 in ipairs(v.objects) do
            Gam:get_level():add_bot_action(
              function()
                v2:on_signal(event)
              end
            )
          end
        end
      end
    end,
    --
    on_collide = function(self, event)
      local dir = event.dir
      local x = self.map_size.x
      local y = self.map_size.y
      if not dir then
        return
      end
      for i, v in pairs(self.groups) do
        for j, v2 in ipairs(v.objects) do
          local can =
            (dir == "left" and v2.mx == x) or (dir == "right" and v2.mx == 1) or (dir == "up" and v2.my == y) or
            (dir == "down" and v2.my == 1)
          if can then
            Gam:get_level():add_bot_action(
              function()
                v2:on_collide(event)
              end
            )
          end
        end
      end
    end,
    --
    block_any_around = function(self, val)
      local vec = Hep.to_vec(val.mx, val.my)
      local m = self:get_map()
      local left = not m:empty_cell(Hep.add_dir(vec, "left"))
      local right = not m:empty_cell(Hep.add_dir(vec, "right"))
      local up = not m:empty_cell(Hep.add_dir(vec, "up"))
      local down = not m:empty_cell(Hep.add_dir(vec, "down"))
      local any = left or right or up or down
      if any then
        return true, {left = left, right = right, up = up, down = down}
      end
      return false, nil
    end,
    --
    get_dir_block = function(self, val, dir)
      return self:get_map():get_cell(Hep.add_dir_v(val.mx, val.my, dir or val.dir))
    end,
    --
    get_around_block = function(self, block)
      local dirs = {"up", "down", "left", "right"}
      local tmp = {}
      for _, v in ipairs(dirs) do
        local target = self:get_map():get_cell(Hep.add_dir_v(block.mx, block.my, v))
        if target and target.uuid then
          tmp[v] = target
        end
      end
      return tmp
    end,
    --
    set_map_position = function(self, x, y, val, anim)
      local cell = self.cell_size
      local tx = cell.x * x
      local ty = cell.y * y

      if val then
        val.mx = x
        val.my = y
        if anim then
          Tw:add_tween(0.1, val, {cx = tx, cy = ty}, "inCubic")
        else
          val.cx = tx
          val.cy = ty
        end
      end
    end
  }
  tmp:to_center()
  local c = tmp.cell_size
  local t = tmp.map_size
  tmp.size.x = c.x * t.x
  tmp.size.y = c.y * t.y
  setmetatable(
    tmp.groups,
    {
      __index = function(self, t)
        if t == "group" then
          return self[1]
        elseif t == "map" then
          return self[2]
        elseif t == "ceiling" then
          return self[3]
        end
      end
    }
  )
  return tmp
end

return screen
