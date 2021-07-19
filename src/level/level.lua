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
    tips = {},
    cursor = nil,
    focus_screen = 1,
    inspect_mode = false,
    is_victory = false,
    --
    update = function(self, dt)
      local actions = self.actions
      for _, v in ipairs(self.screens) do
        v:update(dt)
      end
      if #actions >= 1 then
        self.actions[1]()
        table.remove(self.actions, 1)
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
    end,
    --
    add_screen = function(self, data)
      local s = screen:new(data)
      local screens = self.screens
      screens[#screens + 1] = s
      s.id = #screens
      return s
    end,
    --
    add_screen_inst = function(self, sc)
      local screens = self.screens
      screens[#screens + 1] = sc
      sc.id = #screens
      return sc
    end,
    --
    win = function(self)
      if not self.is_victory then
        self.is_victory = true
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
      for _, v in ipairs(self.screens) do
        v:on_process(event)
      end
    end,
    --
    publish_signal = function(self, event)
      for _, v in ipairs(self.screens) do
        v:on_signal(event)
      end
    end,
    --
    key_pressed = function(self, key, isrepeat)
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

        if any_down then
          self:publish_signal({type = "move", dir = key})
        end

        self:publish_process({})
      end
    end
  }
  tmp:publish_process({})
  return tmp
end

level.load_from_lua = function(self, lua)
  local tmp = self:new()
  tmp.name = Tr("level", lua.name_id).name
  local b = lua.blocks
  local maps = lua.maps
  local blocks = {_ = {}}
  for _, v in pairs(b) do
    local val = Lib:new_final_func(v.type)
    if val then
      blocks[v.sym] = {func = val, data = v.data, child = v.child}
    end
  end
  local index = 0
  local function add_screen(v)
    index = index + 1
    local width = #(v.map[1])
    local height = #v.map
    local draw = index == 1
    -- TODO
    local s = tmp:add_screen({width = width, height = height, draw = true})
    if not draw then
      s:to_position(index - 1)
    end
    for g, group in pairs(v) do
      for i, row in ipairs(group) do
        for j = 1, #row do
          local c = utf8.sub(row, j, j)
          local tb = blocks[c]
          if tb and tb.func then
            s:add_block(j, i, tb:func({}), g)
            if tb.child then
              s:add_screen_to_block(j, i, add_screen(maps[tb.child]), g)
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
