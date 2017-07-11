local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local infection = class('infection')

local MAX_TIME = 511
local INCUBATION_DEFAULT = '1d1' --'1d80+20'
local INFECTION_DAMAGE_PER_TICK = -1

function infection:initialize()
  self.incubation_timer = 0
  self.is_infected = false
end

function infection:add()
print('Player has just been infected!')  
  self.incubation_timer = dice.roll(INCUBATION_DEFAULT)
  self.is_infected = true  
end

function infection:remove(player)
print('Player has been cured of infection!')
  self.incubation_timer = 0
  self.is_infected = false
end

function infection:addImmunity(time) self.incubation_timer = math.min(MAX_TIME, self.incubation_timer + time) end

function infection:isActive() return self.is_infected end

function infection:isImmune() return (self.is_infected and self.incubation_timer > 0) end

function infection:elapse(player, time)
  if not self.is_infected then return end  
    
  if self.incubation_timer > 0 then
    self.incubation_timer = math.max(self.incubation_timer - time, 0)
  else -- infection is no longer dormant
    player:updateStat('hp', INFECTION_DAMAGE_PER_TICK)    
print('Player takes damage for infection!')
  end
end

return infection