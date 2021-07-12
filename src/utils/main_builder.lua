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

  local series_list = UI.Create("list"):SetPos(0, 0):SetSize(width * 0.2, height):SetState("series_menu")

  local list = {"origin_game", "custom_game", "modding"}

  for _, v in ipairs(list) do
    local tmp = UI.Create("button"):SetText(v)
    tmp.OnClick = function(obj, x, y)
      Con.set_state(Gam:set_level({}))
    end
    series_list:AddItem(tmp)
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

return ui_builder
