local level = {}

level.load = function()
  local tmp = {
    blocks = {
      player = {child = 2, type = "block", sym = "P"},
      block1 = {child = 3, type = "block", sym = "1"},
      wall = {type = "wall", sym = "W"}
    },
    maps = {
      {
        map = {
          {"P_________W"},
          {"____1_____W"},
          {"__________W"},
          {"__________W"}
        }
      }
    }
  }
end

return level
