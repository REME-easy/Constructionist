local helper = {}

helper.to_vec = function(x, y)
  return {x = x, y = y}
end

helper.add_dir = function(pos, dir)
  if dir == "up" then
    return {x = pos.x, y = pos.y - 1}
  elseif dir == "down" then
    return {x = pos.x, y = pos.y + 1}
  elseif dir == "left" then
    return {x = pos.x - 1, y = pos.y}
  elseif dir == "right" then
    return {x = pos.x + 1, y = pos.y}
  end
end

helper.dir_to_rot = function(dir)
  if dir == "up" then
    return 0
  elseif dir == "down" then
    return 180
  elseif dir == "left" then
    return 270
  elseif dir == "right" then
    return 90
  end
end

helper.rot_to_dir = function(rot)
  while rot >= 360 do
    rot = rot - 360
  end
  if rot == 0 then
    return "up"
  elseif rot == 90 then
    return "right"
  elseif rot == 180 then
    return "down"
  elseif rot == 270 then
    return "left"
  end
end

helper.flip_dir = function(dir)
  if dir == "left" or dir == "right" then
    return dir == "left" and "right" or "left"
  elseif dir == "up" or dir == "down" then
    return dir == "up" and "down" or "up"
  end
end

helper.add_dir_v = function(x, y, dir)
  if dir == "up" then
    return {x = x, y = y - 1}
  elseif dir == "down" then
    return {x = x, y = y + 1}
  elseif dir == "left" then
    return {x = x - 1, y = y}
  else
    return {x = x + 1, y = y}
  end
end

helper.clone = function(object)
  local tmp = {}
  local function copy(obj)
    if type(obj) ~= "table" then
      return obj
    elseif tmp[obj] then
      return tmp[obj]
    end
    local new_table = {}
    tmp[obj] = new_table
    for key, value in pairs(obj) do
      new_table[copy(key)] = copy(value)
    end
    return setmetatable(new_table, getmetatable(obj))
  end
  return copy(object)
end

helper.print_map = function(map)
  local str = "\n"
  for i, v in ipairs(map) do
    str = str .. string.format("[%d]:{\n", i)
    for j, w in ipairs(v) do
      str = str .. string.format("  [%d] = %s\n", j, w.uuid and w.type or "{}")
    end
    str = str .. "}\n"
  end
  Log(str)
end

return helper
