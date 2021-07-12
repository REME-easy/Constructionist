local library = {
  final = {},
  symbols = {},
  levels = {}
}

library.load = function(self)
  -- 加载方块
  local path = "src/objects/final"
  local files = Fil.load_deep_dir(path)
  Log("loading blocks")
  for _, v in ipairs(files) do
    self.final[v.name] = require(v.path)
  end
  self.final["block"] = require "src.objects.block"
  Log(self.final)

  -- 加载关卡
  path = "levels"
  local _,
    dirs = Fil.load_raw_dir(path)
  Log("loading levels")
  for _, v in ipairs(dirs) do
    local levels = Fil.load_deep_dir(v.path)
    if #levels > 0 then
      self.levels[v.name] = {}
      for _, v2 in ipairs(levels) do
        table.insert(self.levels[v.name], require(v2.path))
      end
    end
  end
end

library.new_final = function(self, id, data)
  if self.final[id] then
    return self.final[id].new(data)
  end
  return {}
end

library.new_final_func = function(self, id)
  if self.final[id] then
    return self.final[id].new
  end
end

return library
