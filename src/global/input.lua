local input = {
  keys = {}
}

input.load = function(self)
  self.keys = {
    left = "left",
    a = "left",
    right = "right",
    d = "right",
    up = "up",
    w = "up",
    down = "down",
    s = "down",
    space = "refresh",
    z = {"confirm", "toggle"},
    x = "cancel",
    lctrl = "undo"
  }
end

setmetatable(
  input,
  {
    __call = function(self, k)
      return self.keys[k]
    end
  }
)

return input
