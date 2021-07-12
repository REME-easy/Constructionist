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
  else
    return {x = pos.x + 1, y = pos.y}
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

return helper
