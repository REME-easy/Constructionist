local file = {}

file.split_string = function(str, pat)
  local t = {} -- NOTE: use {n = 0} in Lua-5.0

  if pat == " " then
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s,
      e,
      cap = utf8.find(str, fpat, 1)
    while s do
      if s ~= #str then
        cap = cap .. " "
      end
      if s ~= 1 or cap ~= "" then
        table.insert(t, cap)
      end
      last_end = e + 1
      s,
        e,
        cap = utf8.find(str, fpat, last_end)
    end
    if last_end <= #str then
      cap = utf8.sub(str, last_end)
      table.insert(t, cap)
    end
  else
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s,
      e,
      cap = utf8.find(str, fpat, 1)
    while s do
      if s ~= 1 or cap ~= "" then
        table.insert(t, cap)
      end
      last_end = e + 1
      s,
        e,
        cap = utf8.find(str, fpat, last_end)
    end
    if last_end <= #str then
      cap = utf8.sub(str, last_end)
      table.insert(t, cap)
    end
  end

  return t
end

file.load_raw_dir = function(path)
  local items = {}
  local dirs = {}
  local files = love.filesystem.getDirectoryItems(path)

  for _, v in ipairs(files) do
    local is_dir =
      love.filesystem.getInfo(path .. "/" .. v) ~= nil and
      love.filesystem.getInfo(path .. "/" .. v)["type"] == "directory"

    if not is_dir then
      local parts = file.split_string(v, "([.])")
      local extension = #parts > 1 and parts[#parts]
      if #parts > 1 then
        parts[#parts] = nil
      end
      local name = table.concat(parts, ".")
      table.insert(
        items,
        {
          fullpath = path .. "/" .. v,
          path = path .. "/" .. name,
          name = name,
          type = extension
        }
      )
    else
      table.insert(
        dirs,
        {
          name = v,
          path = path .. "/" .. v
        }
      )
    end
  end
  return items, dirs
end

file.load_deep_dir = function(path)
  local items = {}
  local files = love.filesystem.getDirectoryItems(path)

  for _, v in ipairs(files) do
    local further = path .. "/" .. v
    local is_dir = love.filesystem.getInfo(further) ~= nil and love.filesystem.getInfo(further)["type"] == "directory"

    if not is_dir then
      local parts = file.split_string(v, "([.])")
      local extension = #parts > 1 and parts[#parts]
      if #parts > 1 then
        parts[#parts] = nil
      end
      local name = table.concat(parts, ".")
      table.insert(
        items,
        {
          fullpath = further,
          path = path .. "/" .. name,
          name = name,
          type = extension
        }
      )
    else
      local tmp = file.load_deep_dir(further)
      for _, v2 in ipairs(tmp) do
        table.insert(items, v2)
      end
    end
  end

  return items
end

return file
