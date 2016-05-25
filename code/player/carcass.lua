local class = require('code.libs.middleclass')
local dice = require('code.libs.rl-dice.dice')

local carcass = class('carcass')
-- carcass description (very fresh|fresh|old meat)
local MAX_FEEDINGS, MAX_INFESTATION = 5, 1023

function carcass:initialize(player) 
  self.carnivour_list = {}
  self.infestation = 0
  self.has_reanimated = player:isMobType('zombie')
end

function carcass:killed(player)
  if player:isMobType('human') then
    local starting_infestation = player.condition.infection.time
    self.infestation = starting_infestation 
  end
end

function carcass:infest(amount)
  self.infestation = self.infestation + amount
  if self.infestation >= MAX_INFESTATION then
    -- add to reanimation list
  end
end

local INFESTATION_DEVOUR_AMT = '1d50+25'
local INFESTATION_DIGESTION_AMT = '1d100+50'

function carcass:devour(player)
  self.carnivour_list[#self.carnivour_list+1] = true
  self.carnivour_list[player] = true
  
  local infestation = player.skills:check('digestion') and INFESTATION_DIGESTION_AMT or INFESTATION_DEVOUR_AMT
  self:infest(dice.rollAndTotal(infestation))
  
  if #self.carnivour_list == MAX_FEEDINGS then 
    self.infestation = MAX_INFESTATION
    -- add to reanimation list
  end
  
  return #self.carnivour_list
end

function carcass:edible(player)   
  local corpse_has_meat = MAX_FEEDINGS > #self.carnivour_list 
  local player_not_eaten_corpse_twice = not self.carnivour_list[player] 
  local corpse_not_zombie = not self.has_reanimated 
  return corpse_has_meat and corpse_not_zombie and player_not_eaten_corpse_twice
end

local INFESTATION_TICK_AMT = '1d5'  -- this should be a server wide (single) roll

function carcass:elapse()
  self:infest(dice.rollAndTotal(INFESTATION_TICK_AMT))
end

function carcass:reanimate()
  self.has_reanimated = true
end

return carcass