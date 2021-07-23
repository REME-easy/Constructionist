local inspector = require "src.level.inspector"
local screen = require "src.level.screen"
local select = require "src.states.select"

local level = {}

level.new = function(self, data)
  local tmp = {
    name = "",
    screens = {},
    actions = {},
    history = {},
    tip = "",
    focus_screen = 1,
    inspect_mode = false,
    is_end = false,
    move_times = 0,
    --
    update = function(self, dt)
      local actions = self.actions
      for _, v in ipairs(self.screens) do
        v:update(dt)
      end
      for i = 1, CONST.UPDATE_TIMES do
        if #actions >= 1 then
          self.actions[1]()
          table.remove(self.actions, 1)
        end
      end
    end,
    --
    draw = function(self)
      local debug = Con.debug

      for _, v in ipairs(self.screens) do
        if v.can_draw then
          v:draw()
          if debug then
            v:draw_debug()
          end
        end
      end
      if self.cursor then
        local screen = self.screens[self.cursor.screen]
        self.cursor:draw(screen.cx, screen.cy)
      end
      if self.tip then
        local width = love.graphics.getWidth()
        local height = love.graphics.getHeight()
        Ast.render_centered_text(self.tip, width / 2, height - 50, width / 2, "center")
      end
    end,
    --
    add_screen = function(self, data)
      local s = screen:new(data)
      table.insert(self.screens, s)
      s.id = #(self.screens)
      return s
    end,
    --
    add_screen_inst = function(self, sc)
      table.insert(self.screens, sc)
      sc.id = #(self.screens)
      return sc
    end,
    --
    win = function(self)
      if not self.is_end then
        self.is_end = true
        Con.set_state(select)
      end
    end,
    --
    lose = function(self)
      if not self.is_end then
        self.is_end = true
        Con.set_state(select)
      end
    end,
    --
    add_bot_action = function(self, action)
      table.insert(self.actions, action)
    end,
    --
    add_top_action = function(self, action)
      table.insert(self.actions, 2, action)
    end,
    --
    publish_process = function(self, event)
      self.screens[1]:on_process(event)
    end,
    --
    publish_signal = function(self, event)
      self.screens[1]:on_signal(event)
    end,
    --
    key_pressed = function(self, key, isrepeat)
      if self.is_end or #(self.actions) > 0 then
        return
      end
      if self.inspect_mode then
        if key == "toggle" then
          self.inspect_mode = false
          self.cursor = nil
        elseif key == "confirm" then
        -- TODO
        end

        local left = key == "left"
        local right = key == "right"
        local up = key == "up"
        local down = key == "down"
        local any_down = left or right or up or down
        -- TODO
        if any_down then
          local cursor = self.cursor
          local tar = Hep.add_dir_v(cursor.mx, cursor.my, key)
          self.screens[cursor.screen]:set_map_position(tar.x, tar.y, cursor, true)
        end
      else
        -- for _, v in ipairs(self.screens) do
        --   Log(#(v.groups.map.objects))
        --   Log("======\n")
        -- end
        if key == "toggle" then
          self.inspect_mode = true
          local tmp = inspector:new()
          tmp.screen = self.focus_screen
          self.cursor = tmp
          return
        end
        local left = key == "left"
        local right = key == "right"
        local up = key == "up"
        local down = key == "down"
        local any_down = left or right or up or down

        self:publish_signal({type = "clear"})
        if any_down then
          self:publish_signal({type = "move", dir = key})
          self.move_times = self.move_times + 1
        end

        self:publish_process({})
      end
    end
  }
  return tmp
end

level.load_from_lua = function(self, lua, text)
  local tmp = self:new()
  local b = lua.blocks
  local maps = lua.maps
  local blocks = {_ = {}}
  if text then
    if text.name then
      tmp.name = text.name
    end
    if text.tip then
      tmp.tip = text.tip
    end
  end
  for _, v in pairs(b) do
    local val = Lib:new_final_func(v.type)
    if val then
      blocks[v.sym] = {func = val, data = v.data, child = v.child}
    end
  end
  local index = 0
  local function add_screen(data)
    index = index + 1
    local width = #(data.map[1])
    local height = #data.map
    local draw = index == 1
    -- TODO
    local s = tmp:add_screen({width = width, height = height, draw = true})
    if not draw then
      s:to_position(index - 1)
    end
    for g, group in pairs(data) do
      for i, row in ipairs(group) do
        for j = 1, #row do
          local c = utf8.sub(row, j, j)
          local tb = blocks[c]
          if tb and tb.func then
            s:add_block(j, i, tb:func({}), g)
            if tb.child then
              s:add_screen_to_block(j, i, add_screen(maps[tb.child]), g, true)
            end
          end
        end
      end
    end
    return s
  end

  add_screen(maps[1])
  return tmp
end

return level
