local inspector = {}

inspector.new = function(self)
  local tmp = {
    cx = 0,
    cy = 0,
    scale = 0.5,
    mx = 0,
    my = 0,
    screen = 1,
    draw = function(self, cx, cy)
      local x = cx and self.cx + cx or self.cx
      local y = cy and self.cy + cy or self.cy
      love.graphics.draw(Ast.images.select, x, y, 0, self.scale, self.scale)
    end
  }
  local screen = Gam:get_screen(tmp.screen)
  local x,
    y = math.floor(screen.map_size.x / 2), math.floor(screen.map_size.y / 2)
  Gam:get_screen(tmp.screen):set_map_position(x, y, tmp)
  return tmp
end

return inspector
