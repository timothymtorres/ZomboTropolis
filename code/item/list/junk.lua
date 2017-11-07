local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

local Book = class('Book', ItemBase)

Book.static = {
  FULL_NAME = 'book',
  WEIGHT = 2,
  CATEGORY = 'research',
  DURABILITY = 0,
}

local book_xp_dice = {'1d3', '1d5', '1d7', '1d10'}

function Book.activate(player, condition)
  local xp_dice_str = book_xp_dice[condition-1]
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

Bottle.static = {
  FULL_NAME = 'bottle',
  WEIGHT = 1,
  DURABILITY = 0,
}

function Bottle.activate(player, condition)
  player:updateHP(1)
  
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

local Newspaper = class('Newspaper', ItemBase)

Newspaper.static = {
  FULL_NAME = 'newspaper',
  WEIGHT = 1,
  DURABILITY = 0,
}

--function Newspaper.activate(player, condition) end

return {Book, Bottle, Newspaper}