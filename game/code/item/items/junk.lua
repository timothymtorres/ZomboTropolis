local dice = require('code.libs.dice')
string.replace = require('code.libs.replace')

local Junk = {}

-------------------------------------------------------------------

local Book = {}
Junk.Book = Book

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
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'book', player}  
  player.log:insert(msg, event)    
end

-------------------------------------------------------------------

local Bottle = {}
Junk.Bottle = Bottle

function Bottle:activate(player)
  player:updateHP(self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You drink some liquor from the bottle.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'bottle', player}  
  player.log:insert(msg, event)   
end

-------------------------------------------------------------------

local Newspaper = {}
Junk.Newspaper = Newspaper

--function Newspaper.activate(player, condition) end

return Junk