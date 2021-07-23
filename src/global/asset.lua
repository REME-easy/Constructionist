local ast = {
  images = {}
}

ast.load = function(self)
  local font_path = "assets/fonts/NotoSansHans-Bold.otf"
  self.hansFont = love.graphics.newFont(font_path, 20)
  self.smallHansFont = love.graphics.newFont(font_path, 14)
  for _, skin in pairs(UI.skins) do
    skin.controls.smallfont = love.graphics.newFont(font_path, 15)
    skin.controls.imagebuttonfont = love.graphics.newFont(font_path, 20)
  end
  love.graphics.setFont(love.graphics.newFont(font_path, 12))

  local path = "assets/textures"
  local files = Fil.load_deep_dir(path)
  Log(files)
  for _, v in ipairs(files) do
    self.images[v.name] = love.graphics.newImage(v.fullpath)
  end
  Log(self.images)
end

ast.render_centered_text = function(text, x, y, limit, align)
  local font = love.graphics.getFont()
  local tx = x - font:getWidth(text) / 2
  local ty = y - font:getHeight() / 2
  love.graphics.printf(text, tx, ty, limit or love.graphics.getWidth(), align or "center")
end

return ast
