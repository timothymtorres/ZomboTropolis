local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsArmor = require('code.item.mixin.is_armor')
local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

-------------------------------------------------------------------

local Armor = class('Armor', Item):include(IsArmor)

Armor.ap = {cost = 1} -- default AP cost for armor

function Armor:activate(player)
  if player.equipment:isActive('armor') then -- remove old armor and put into inventory 
    local old_armor = player.equipment.armor
    player.inventory:insert(old_armor) 
  end
  player.equipment:add('armor', self)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You equip a {armor}.'
  msg = msg:replace(self) -- This should work? Needs to be tested

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'armor', player}
  player.log:insert(msg, event)
end

-------------------------------------------------------------------

local Leather = class('Leather', Armor)

Leather.FULL_NAME = 'leather jacket'
Leather.DURABILITY = 32
Leather.CATEGORY = 'military'

Leather.armor = {}
Leather.armor.resistance = {blunt=1}

-------------------------------------------------------------------

local Firesuit = class('Firesuit', Armor)

Firesuit.FULL_NAME = 'firesuit'
Firesuit.DURABILITY = 4
Firesuit.CATEGORY = 'military'

Firesuit.armor = {}
Firesuit.armor.resistance = {
  {acid=1},
  {acid=2},
  {acid=3},
  {acid=4},
}

return {Leather, Firesuit} -- Add a biohazard suit that prevents infection but is fragile