local start_time = love.timer.getTime()

test = {}

function getTime()
  return string.format("%.4f", (love.timer.getTime() - start_time) * 1660)
end

function test.logger(msg)
  print(getTime() .. ">>>" .. msg)
end

-- log输出格式化
local function logPrint(str)
  str = os.date("Log output date: %Y-%m-%d %H:%M:%S \n", os.time()) .. str
  print(getTime() .. ">>>" .. str)
end

-- key值格式化
local function formatKey(key)
  local t = type(key)
  if t == "number" then
    return "[" .. key .. "]"
  elseif t == "string" then
    local n = tonumber(key)
    if n then
      return "[" .. key .. "]"
    end
  end
  return key
end

-- 栈
local function newStack()
  local stack = {
    tableList = {}
  }
  function stack:push(t)
    table.insert(self.tableList, t)
  end
  function stack:pop()
    return table.remove(self.tableList)
  end
  function stack:contains(t)
    for _, v in ipairs(self.tableList) do
      if v == t then
        return true
      end
    end
    return false
  end
  return stack
end

-- 输出打印table表 函数
function test.printTable(...)
  local args = {...}
  for k, v in pairs(args) do
    local root = v
    if type(root) == "table" then
      local temp = {
        "------------------------ printTable start ------------------------\n",
        "local tableValue" .. " = {\n"
      }
      local stack = newStack()
      local function table2String(t, depth)
        stack:push(t)
        if type(depth) == "number" then
          depth = depth + 1
        else
          depth = 1
        end
        local indent = ""
        for i = 1, depth do
          indent = indent .. "    "
        end
        for k, v in pairs(t) do
          local key = tostring(k)
          local typeV = type(v)
          if typeV == "table" then
            if key ~= "__valuePrototype" then
              if stack:contains(v) then
                table.insert(temp, indent .. formatKey(key) .. " = {loop reference!},\n")
              else
                table.insert(temp, indent .. formatKey(key) .. " = {\n")
                table2String(v, depth)
                table.insert(temp, indent .. "},\n")
              end
            end
          elseif typeV == "string" then
            table.insert(temp, string.format('%s%s = "%s",\n', indent, formatKey(key), tostring(v)))
          else
            table.insert(temp, string.format("%s%s = %s,\n", indent, formatKey(key), tostring(v)))
          end
        end
        stack:pop()
      end
      table2String(root)
      table.insert(temp, "}\n------------------------- printTable end -------------------------")
      logPrint(table.concat(temp))
    else
      logPrint(
        "----------------------- printString start ------------------------\n" ..
          tostring(root) .. "\n------------------------ printString end -------------------------"
      )
    end
  end
end

setmetatable(
  test,
  {
    __call = function(self, t)
      if type(t) == "table" then
        self.printTable(t)
      else
        self.logger(tostring(t))
      end
    end
  }
)

return test
