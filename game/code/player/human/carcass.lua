local class = require('code.libs.middleclass')

local Carcass = class('Carcass')
local MAX_FEEDINGS = 4

function Carcass:initialize(player)
  self.player = player
  self.carnivour_list = {}
end

function Carcass:devour(zombie)
  self.carnivour_list[#self.carnivour_list+1] = true
  self.carnivour_list[zombie] = true
  
  if #self.carnivour_list == MAX_FEEDINGS then 
    -- add to reanimation list
    -- self.player
  end
  
  return #self.carnivour_list
end

function Carcass:edible(zombie)   
  local corpse_has_meat = MAX_FEEDINGS > #self.carnivour_list 
  local zombie_not_eaten_corpse_twice = not self.carnivour_list[zombie] 
  return corpse_has_meat and zombie_not_eaten_corpse_twice
end

return Carcass