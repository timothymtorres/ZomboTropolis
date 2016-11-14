local class = require('code.libs.middleclass')
local item_armor_list = require('code.item.list.armor')
local armor = require('code.player.armor.class')

local item_armor = class('item_armor', armor)

function item_armor:initialize(player)
  armor.initialize(self, player) 
end

function item_armor:equip(name, condition, inv_ID)
  self.protection = item_armor_list[name].resistance[condition]
  self.name, self.inv_ID, self.condition = name, inv_ID, condition
  self.durability = item_armor_list[name].durability
end

function item_armor:degrade(player)
  local item_INST = player.inventory:lookup(self.inv_ID)
  item_INST:updateCondition(-1, player, self.inv_ID)
  
  self.condition = self.condition - 1
  if 0 > self.condition then -- armor is destroyed
    local player = self.player
    player.armor = item_armor:new(player)
    return  -- something to tell that armor is destroyed?
  end
  self.protection = item_armor_list[self.name].resistance[self.condition]
end

return armor