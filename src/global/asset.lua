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

return ast
