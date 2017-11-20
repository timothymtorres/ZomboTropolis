local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local dice =           require('code.libs.dice')
local broadcastEvent = require('code.server.event')
local isWeapon =       require('code.item.mixin.is_weapon')
string.replace =       require('code.libs.replace')

local Book = class('Book', ItemBase)

Book.FULL_NAME = 'book'
Book.WEIGHT = 2
Book.CATEGORY = 'research'
Book.DURABILITY = 0

local book_xp_dice = {'1d3', '1d5', '1d7', '1d10'}

function Book:activate(player)
  local xp_dice_str = book_xp_dice[self.condition]
  local book_dice = dice:new(xp_dice_str)
  local tile = player:getTile()
 
  if tile:isBuilding() and tile:isPowered() and player:isStaged('inside') then book_dice = book_dice^1 end  
  local gained_xp = book_dice:roll()
  player:updateXP(gained_xp)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You read a book {lighting} and gain knowledge.'  
  msg = msg:replace(tile:isPowered() and 'in the light' or '')
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'book', player}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(msg, event)    
end

-------------------------------------------------------------------

local Bottle = class('Bottle', ItemBase)

Bottle.FULL_NAME = 'bottle'
Bottle.WEIGHT = 1
Bottle.DURABILITY = 0

function Bottle:activate(player)
  player:updateHP(self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You drink some liquor from the bottle.'
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'bottle', player}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(msg, event)   
end

-------------------------------------------------------------------

local Newspaper = class('Newspaper', ItemBase):include(isWeapon)

Newspaper.FULL_NAME = 'newspaper'
Newspaper.WEIGHT = 1
Newspaper.DURABILITY = 0

Newspaper.weapon = {
  ACCURACY = 1.00,
  NO_DAMAGE = true,
}

--function Newspaper.activate(player, condition) end

return {Book, Bottle, Newspaper}