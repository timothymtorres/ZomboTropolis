local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local Infection = class('Infection')

local INFECTION_DAMAGE_PER_TICK = -1

function Infection:initialize(player)
  self.player = player
end

function Infection:elapse(player, time)  
  if not self.player.status_condition:isActive('immune') then
    player.log:append('You feel the infection spreading.')    
    player:updateStat('hp', INFECTION_DAMAGE_PER_TICK*time)    
  end
end

return Infection