local Entangle =  require('code.player.status_effect.entangle')
local Burn = 	  require('code.player.zombie.status_effect.burn')
local Track =     require('code.player.zombie.status_effect.track')

local effects = {Entangle, Burn, Track}

for _, Class in ipairs(effects) do
  effects[Class.name] = Class
end

return effects