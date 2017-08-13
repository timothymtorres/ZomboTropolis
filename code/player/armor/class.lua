local dice = require('code.libs.dice')
local item_armor_list = require('code.player.armor.item_list')
local class = require('code.libs.middleclass')

local armor = class('armor')

function armor:initialize(player) 
  self.player = player
end

-- Possibly consider redoing armor for the zombies?  Make it similiar to human armor or less complex... if it's made to be similiar to human armor, it will shrink
-- down the code in this file quite a bit, no need to differenate between human/zombie mobtypes

function armor:failDurabilityCheck(degrade_chance) 
   local player, protection = self.player
  
  if player:isMobType('human') then return dice.roll(item_armor_list[self.name].durability) <= degrade_chance
  elseif player:isMobType('zombie') then return dice.roll(self.durability) <= degrade_chance
  end
end 

function armor:getProtection(damage_type) 
  local player, protection = self.player
  
  if player:isMobType('human') then return item_armor_list[self.name].resistance[self.condition][damage_type] or 0
  elseif player:isMobType('zombie') then return self.protection[damage_type] or 0 
  end
end

function armor:isPresent() 
  if player:isMobType('human') then return self.name and true or false
  elseif player:isMobType('zombie') then return self.protection and true or false 
  end
end

return armor