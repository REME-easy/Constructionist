Log = require "test"
UI = require "lib.loveframes"
Tw = require "lib.tweens"
utf8 = require "lib.utf8":init()
Fil = require "src.global.file"
Ast = require "src.global.asset"
Set = require "src.global.settings"
Inp = require "src.global.input"
Hep = require "src.global.helper"
Tr = require "src.global.locale"
Lib = require "src.global.library"
Gam = require "src.states.game"

local menu = require "src.states.menu"

Con = {
  version = "DEBUG v0.1",
  debug = true,
  timer = 0.0,
  cur_state = nil,
  new_state = nil,
  UI = require "src.utils.main_builder",
  controls = {}
}

Con.set_state = function(state, quick)
  if Con.timer <= 0.0 then
    Con.new_state = state
    if quick then
      Con.timer = 0.1
    else
      Con.timer = 0.4
    end
  end
end

love.load = function(args)
  -- love.graphics.setDefaultFilter("nearest", "nearest")
  Log(Con)
  Ast:load()
  Lib:load()
  Inp:load()
  Con.set_state(menu, true)
end

love.update = function(dt)
  local timer = Con.timer
  local new = Con.new_state
  if Con.cur_state then
    Con.cur_state:update(dt)
  end
  UI.update(dt)
  Tw:update(dt)
  if timer > 0 then
    Con.timer = timer - dt
    if Con.timer <= 0 and new then
      Con.timer = 0
      UI.SetState(new.name)
      for _, v in ipairs(Con.controls) do
        v:Remove()
      end
      Con.controls = Con.UI["build_" .. new.name]()
      Con.cur_state = new
      Con.cur_state:init()
      Con.new_state = nil
    end
  end
end

love.draw = function()
  local state = Con.cur_state
  local timer = Con.timer
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  if Con.cur_state then
    Con.cur_state:draw()
  end
  UI.draw()
  if timer > 0 then
    love.graphics.setColor(0, 0, 0, 1 - timer / 0.4)
    love.graphics.rectangle("fill", 0, 0, width, height)
  end
end

love.resize = function(w, h)
  -- if camera then
  --   camera:setWindow(0, 0, w, h)
  -- end
end

love.mousepressed = function(x, y, button)
  UI.mousepressed(x, y, button)
end

love.mousereleased = function(x, y, button)
  UI.mousereleased(x, y, button)
end

love.wheelmoved = function(x, y)
  UI.wheelmoved(x, y)
end

love.keypressed = function(key, scancode, isrepeat)
  UI.keypressed(key, isrepeat)
  if Con.cur_state.keypressed then
    local tmp = Inp(key)
    if type(tmp) == "table" then
      for _, v in ipairs(tmp) do
        Con.cur_state:keypressed(v, isrepeat)
      end
    else
      Con.cur_state:keypressed(tmp, isrepeat)
    end
  end
end

love.keyreleased = function(key)
  UI.keyreleased(key)
  if key == "f1" and Con.debug then
    local debug = UI.config["DEBUG"]
    UI.config["DEBUG"] = not debug
  end
end

love.textinput = function(text)
  UI.textinput(text)
end
