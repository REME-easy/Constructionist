local locale = {}

locale.loadLocale = function(self, k, path)
  local locales = self.locales
  if (locales[k]) then
    local new = require(path)
    for _, v in pairs(new) do
      table.insert(locales[k], v)
    end
  else
    locales[k] =
      setmetatable(
      require(path),
      {
        __index = function(t, k)
          return "[MISSING]"
        end
      }
    )
  end
end

locale.get = function(self, k)
  return self.locales[k]
end

locale.translate = function(self, k, id, t)
  local txt = self:get(k)
  if not t then
    if not id then
      return txt
    else
      return txt[id]
    end
  elseif type(t) == "table" then
    if not id then
      return nil
    end
    if not txt[id] then
      t.name = "[MISSING]"
      t.description = "[MISSING]"
      t.extension = "[MISSING]"
    else
      local tmp = txt[id]
      t.name = tmp.name or "[MISSING]"
      t.description = tmp.description or "[MISSING]"
      t.extension = tmp.extension or "[MISSING]"
    end
  end
  return nil
end

local path = "assets/locale/" .. Set.language .. "/"
local head = Fil.load_raw_dir(path)
locale.locales = {}
for _, v in pairs(head) do
  locale:loadLocale(v.name, v.path)
end
locale.locales =
  setmetatable(
  locale.locales,
  {
    __newindex = function(t, k, v)
      Log("table is readonly")
    end
  }
)

setmetatable(
  locale,
  {
    __call = function(self, k, id, t)
      return locale:translate(k, id, t)
    end
  }
)

return locale
