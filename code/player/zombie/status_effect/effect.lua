local Entangle =  require('code.player.status_effect.entangle')
local Burn = 	  require('code.player.zombie.status_effect.burn')
local Track =     require('code.player.zombie.status_effect.track')

local effect = {Entangle, Burn, Track}

for _, Class in ipairs(effect) do
  local class_name = string.lower(Class.name)
  effect[class_name] = Class
end

return effect