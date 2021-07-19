local select = require "src.states.select"

local ui_builder = {}

ui_builder.build_start_menu = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local txt = Tr("ui", "start_menu")

  local title =
    UI.Create("text"):SetPos(width * 0.5 - 30, height * 0.5 - 100):SetText(
    {{font = Ast.hansFont, color = {1, 1, 1, 1}}, txt.title}
  ):SetState("start_menu")

  local start_button =
    UI.Create("button"):SetPos(width * 0.4, height * 0.5 - 50):SetSize(width * 0.2, 50):SetText(txt.start):SetState(
    "start_menu"
  )
  start_button.OnClick = function(obj, x, y)
    Con.set_state(select)
  end

  local editor_button =
    UI.Create("button"):SetPos(width * 0.4, height * 0.5):SetSize(width * 0.2, 50):SetText(txt.editor):SetState(
    "start_menu"
  )

  local option_button =
    UI.Create("button"):SetPos(width * 0.4, height * 0.5 + 50):SetSize(width * 0.2, 50):SetText(txt.option):SetState(
    "start_menu"
  )

  local exit_button =
    UI.Create("button"):SetPos(width * 0.4, height * 0.5 + 100):SetSize(width * 0.2, 50):SetText(txt.exit):SetState(
    "start_menu"
  )
  exit_button.OnClick = function(obj, x, y)
    love.event.quit()
  end

  return {title, start_button, editor_button, option_button, exit_button}
end

ui_builder.build_series_menu = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local txt = Tr("level")

  local series_list = UI.Create("list"):SetPos(0, 0):SetSize(width * 0.2, height):SetState("series_menu")

  for k, v in pairs(Lib.levels) do
    local category = UI.Create("collapsiblecategory")
    local category_list = UI.Create("panel")
    local category_height = 0
    for i, v2 in ipairs(v) do
      local name = txt[k][i] and txt[k][i].name or "[MISSING]"
      local btn = UI.Create("button", category_list):SetText(name):SetY(category_height)
      btn.OnClick = function(obj, x, y)
        Con.set_state(Gam:set_level(v2))
      end
      category_height = category_height + 30
    end
    category_list:SetHeight(category_height)
    category:SetObject(category_list)
    series_list:AddItem(category)
  end

  return {series_list}
end

ui_builder.build_game = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local txt = Tr("ui", "game")

  local top_panel = UI.Create("panel"):SetPos(0, 0):SetSize(width, 30):SetState("game")

  local top_info =
    UI.Create("text", top_panel):SetPos(5, 5):SetText(
    {
      {font = Ast.smallHansFont, color = {0, 0, 0, 1}},
      txt.level_name .. "      " .. txt.move_amount
    }
  )

  local back = UI.Create("button", top_panel):SetPos(width - 55, 5):SetSize(45, 20):SetText("back")
  back.OnClick = function(obj, x, y)
    Con.set_state(select)
  end

  return {top_panel}
end

ui_builder.build_settings = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local txt = Tr("ui", "settings")

  local settings_panel =
    UI.Create("panel"):SetPos(width * 0.1, height * 0.1):SetSize(width * 0.8, height * 0.8):SetState("settings")

  local left_list = UI.Create("list")
end

ui_builder.create_map_tab = function()
end

ui_builder.build_editor = function()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local txt = Tr("ui", "editor")

  local block_list = UI.Create("list"):SetPos(0, 0):SetSize(100, height):SetState("editor")
  --TODO add blocks
  local blocks = Lib.final
  for k, v in pairs(blocks) do
  end

  local map_tabs = UI.Create("tabs"):SetPos(100, 0):SetSize(width - 100, height)
end

return ui_builder
