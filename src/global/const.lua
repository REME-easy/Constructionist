local const = {
  table = {
    UPDATE_TIMES = 2
  }
}

const.add_const = function(self, table)
  for k, v in ipairs(table) do
    if not self.table[k] then
      self.table[k] = v
    else
      Log("Add existing const!!!")
    end
  end
end

setmetatable(
  const,
  {
    __index = function(self, obj)
      if obj ~= "add_const" then
        return self.table[obj]
      end
      return self[obj]
    end
  }
)

return const
