local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local Hunger = class('Hunger')

local MAX_HUNGER, MAX_HUNGER_BONUS = 800, 1000

function Hunger:initialize(player)
  self.player = player
  self.hunger = 0
end

function Hunger:update(amt) 	
  self.hunger = math.max(self.hunger + amt, 0)
  local hunger_threshold = player.skills:check('satiation_bonus') and MAX_HUNGER_BONUS or MAX_HUNGER

  if self.hunger >= hunger_threshold then
  	for i=1, hunger_threshold - self.hunger do 
	  	if dice.roll(10) == 1 then
	  	  return self.player:starve() -- game over pal
	  	end
    end
    
	  self.hunger = hunger_threshold
	  local player = self.player   	  
	  player.log:append('You are starving!')
  end
end

function Hunger:elapse(time)
  self:update(time)
  -- should we even have this?  
end

function Hunger:getHunger() return self.hunger end

return Hunger