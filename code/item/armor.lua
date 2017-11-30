local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')

local Leather = class('Leather', ItemBase)

Leather.FULL_NAME = 'leather jacket'
Leather.DURABILITY = 0
Leather.CATEGORY = 'military'

function Leather:activate(player)
  player.armor:equip('leather', self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You equip a leather jacket.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'leather', player}  
  player.log:insert(msg, event)  
end

-------------------------------------------------------------------

local Firesuit = class('Firesuit', ItemBase)

Firesuit.FULL_NAME = 'firesuit'
Firesuit.DURABILITY = 0
Firesuit.CATEGORY = 'military'

function Firesuit:activate(player)
  player.armor:equip('firesuit', self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You equip a firesuit.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'firesuit', player}  
  player.log:insert(msg, event)  
end

return {Leather, Firesuit}