local map = require "src.level.map"

local screen = {}

screen.new = function(self, data)
  Log(data)
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
      self.cy = 50 + 160 * index % 3

      local tx = index <= 3 and 10 or width - self.size.x - 10

      Tw:add_tween(0.2, self, {cx = tx}, "inCubic")
    end,
    --
    get_map = function(self)
      return self.groups.map
    end,
    --
    add_block = function(self, x, y, val, group)
      local g = self.groups[group or "map"]
      val.parent_map = self.id
      self:set_block(x, y, val, false, group or "map")
      return val
    end,
    --
    remove_block = function(self, x, y, val)
    end,
    --
    set_block = function(self, x, y, val, anim, group)
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

      self.groups[group]:set_cell(x, y, val)
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
    add_screen_to_block = function(self, x, y, index, group)
      local g = self.groups[group]
      if not g then
        return
      end
      local val = g:get_cell(x, y)
      if val.uuid and val.parent_map ~= index then
        Gam:get_screen(index).parent = val
        val.child_map = index
      end
    end,
    --
    on_process = function(self, event)
      for i, v in pairs(self.groups) do
        for j, v2 in ipairs(v.objects) do
          v2:on_process(event)
        end
      end
    end,
    --
    on_signal = function(self, event)
      for i, v in pairs(self.groups) do
        for j, v2 in ipairs(v.objects) do
          v2:on_signal(event)
        end
      end
    end,
    --
    block_any_around = function(self, val)
      local vec = Hep.to_vec(val.mx, val.my)
      local map = self:get_map()
      local left = not map:empty_cell(Hep.add_dir(vec, "left"))
      local right = not map:empty_cell(Hep.add_dir(vec, "right"))
      local up = not map:empty_cell(Hep.add_dir(vec, "up"))
      local down = not map:empty_cell(Hep.add_dir(vec, "down"))
      if left or right or up or down then
        return {left = left, right = right, up = up, down = down}
      end
      return nil
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