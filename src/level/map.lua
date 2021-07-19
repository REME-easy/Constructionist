local map = {}

map.new = function(self, data)
  local tmp = {
    id = data.id or 1,
    array = {},
    objects = {},
    width = data.w or 1,
    height = data.h or 1,
    size = 0,
    update = function(self, dt)
      for _, v in ipairs(self.objects) do
        v:update(dt)
      end
    end,
    draw = function(self, cx, cy)
      for _, v in ipairs(self.objects) do
        v:draw(cx, cy)
      end
    end,
    get_cell = function(self, x, y)
      if y then
        if x <= self.width and y <= self.height and self.array[y] and self.array[y][x] then
          return self.array[y][x]
        end
        return nil
      else
        local pos = x
        if pos.x <= self.width and pos.y <= self.height and self.array[pos.y] and self.array[pos.y][pos.x] then
          return self.array[pos.y][pos.x]
        end
        return nil
      end
    end,
    valid_cell = function(self, x, y)
      if y then
        return self:get_cell(x, y) ~= nil
      else
        local pos = x
        return self:get_cell(pos.x, pos.y) ~= nil
      end
    end,
    empty_cell = function(self, x, y)
      if y then
        local cell = self:get_cell(x, y)
        if cell then
          if not cell.type or cell.type == "empty" then
            return true
          else
            return false
          end
        end
        return true
      else
        local pos = x
        local cell = self:get_cell(pos.x, pos.y)
        if cell then
          if not cell.type or cell.type == "empty" then
            return true
          else
            return false
          end
        end
        return true
      end
    end,
    set_cell = function(self, x, y, val)
      if self:valid_cell(x, y) then
        if not self.array[y][x].type and val.type then
          local dup = false
          for _, v in ipairs(self.objects) do
            if v == val then
              dup = true
            end
          end
          if not dup then
            table.insert(self.objects, val)
          end
        end
        self.array[y][x] = val
        return true
      end
      return false
    end,
    swap_cell = function(self, x1, y1, x2, y2)
      if self:valid_cell(x1, y1) and self:valid_cell(x2, y2) then
        local tmp = self.array[y1][x1]
        self.array[y1][x1] = self.array[y2][x2]
        self.array[y2][x2] = tmp
      end
    end
  }
  for i = 1, tmp.height do
    tmp.array[i] = {}
    for j = 1, tmp.width do
      tmp.array[i][j] = {}
    end
  end
  return tmp
end

setmetatable(
  map,
  {
    __tostring = function(self)
      return string.format('cell_map : "%s" [%d,%d]', self.id, self.width, self.height)
    end
  }
)

return map
