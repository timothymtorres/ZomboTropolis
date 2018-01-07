local class = require('code.libs.middleclass')

local Burn = class('Burn')

local BURN_DAMAGE_PER_TICK = -1

function Burn:initialize(player)
  self.player = player
end

function Burn:elapse(time)
  local player = self.player   
  player.log:append('You burn in agony!')    
  player:updateStat('hp', BURN_DAMAGE_PER_TICK*time)    
end

return Burn