local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local infection = class('infection')

local MAX_TIME = 511
local INCUBATION_DEFAULT = '1d1' --'1d80+20'
local INFECTION_DAMAGE_PER_TICK = -1

function infection:initialize(player)
  self.player = player
end

function infection:isImmune() return self.incubation_timer > 0 end

function infection:elapse(player, time)  
  if not self.player.status_condition:isActive('immune') then
    player.log:append('You feel the infection spreading.')    
    player:updateStat('hp', INFECTION_DAMAGE_PER_TICK*time)    
  end
end

return infection