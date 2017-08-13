local class =           require('code.libs.middleclass')
local item_armor_list = require('code.item.list.armor')
local item =            require('code.item.class')  
local armor =           require('code.player.armor.class')

local item_armor = class('item_armor', armor)

function item_armor:initialize(player)
  armor.initialize(self, player) 
end

function item_armor:equip(name, condition)
  if self:isPresent() then self:remove() end -- unequips the old armor and puts it back into the inventory
  self.name, self.condition = name, condition  
end

function item_armor:remove()
  local player, armor_type, condition = self.player, self.name, self.condition
  local armor_INST = item[armor_type]:new(condition)
  
  player.inventory:insert(armor_INST)
  self.name, self.condition = nil, nil
end

function item_armor:degrade(player)
  self.condition = self.condition - 1
  if 0 > self.condition then -- armor is destroyed
    self.name, self.condition = nil, nil
    return  -- something to tell that armor is destroyed?
  end
end

return item_armor