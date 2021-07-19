local block = require "src.objects.block"

local button = {}

button.new = function(data)
  local tmp = block.new(data)
  tmp.type = "button"
  tmp.img = "button"
  tmp.can_push = true
  tmp.energy_color = {0, 1, 0, 1}
  tmp.toggled = false

  tmp:add_trigger(
    "process",
    "button",
    function(self, event)
      local dirs = self:get_parent():block_any_around(self)
      if not self.toggled and dirs then
        for k, v in pairs(dirs) do
          if v then
            self:add_current(1, k)
          end
        end
        self.energy_color = {1, 0, 0, 1}
        self.toggled = true
      elseif self.toggled and not dirs then
        self.current = {}
        self.energy_color = {0, 1, 0, 1}
        self.toggled = false
      end
    end
  )

  tmp.draw = function(self, cx, cy)
    local x = cx and self.cx + cx or self.cx
    local y = cy and self.cy + cy or self.cy
    love.graphics.setColor(unpack(self.energy_color))
    love.graphics.rectangle("fill", x, y, 64 * self.size, 64 * self.size)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(Ast.images[self.img], x, y, self.rot, self.size, self.size)
    love.graphics.print(string.format("(%d,%d)", self.mx, self.my), x, y)
  end

  return tmp
end

return button
