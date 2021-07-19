local level = require "src.level.level"

local game = {
  name = "game"
}

game.set_level = function(self, file)
  self.level = level:new()
  -- TODO
  -- local s = self.level:add_screen({width = 10, height = 10, draw = true})
  -- s:add_block(1, 1, Lib:new_final("mover", {}))
  -- s:add_block(3, 3, Lib:new_final("box", {}))
  -- s:add_block(5, 5, Lib:new_final("box", {}))
  -- s:add_block(7, 7, Lib:new_final("rebot", {}))
  -- s:add_block(6, 6, Lib:new_final("button", {}))
  -- s:add_block(8, 8, Lib:new_final("collide_flag", {}))
  -- for i = 3, 9 do
  --   s:add_block(4, i, Lib:new_final("wall", {}))
  -- end

  -- local s2 = self.level:add_screen({width = 5, height = 5, draw = true})
  -- s:add_screen_to_block(7, 7, 2, "map")
  -- s2:to_position(1)
  -- s2:add_block(3, 3, Lib:new_final("mover", {}))

  self.level = level:load_from_lua(file)
  Log(self.level)
  return self
end

game.init = function(self)
end

game.update = function(self, dt)
  self.level:update(dt)
end

game.draw = function(self)
  self.level:draw()
end

game.get_level = function(self)
  return self.level
end

game.get_screen = function(self, id)
  return self.level.screens[id]
end

game.get_map = function(self, id)
  return self.level.screens[id]:get_map()
end

game.keypressed = function(self, key, isrepeat)
  self.level:key_pressed(key, isrepeat)
end

game.keyreleased = function(self, key)
end

return game
