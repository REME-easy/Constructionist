
local tween = require "lib.tween"

local tweens = {}

tweens.lib = tween
tweens.tws = {}

tweens.add_tween = function(self, duration, object, target, easing)
  table.insert(self.tws, tween.new(duration, object, target, easing))
end

tweens.update = function(self, dt)
  local tws = self.tws
  for i = #tws, 1, -1 do
    local t = self.tws[i]
    if(t:update(dt)) then
      table.remove(self.tws, i)
    end
  end
end

return tweens
