local class = require('code.libs.middleclass')

local Infection = class('Infection')

local INFECTION_DAMAGE_PER_TICK = -1

function Infection:initialize(player)
  self.player = player
end

function Infection:elapse(time) 
  local player = self.player 
  if not player.status_condition:isActive('immune') then
    player.log:append('You feel the infection spreading.')    
    player:updateStat('hp', INFECTION_DAMAGE_PER_TICK*time)    
  end
end

return Infection