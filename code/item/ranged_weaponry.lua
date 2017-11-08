local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')

-- need to add designated_weapon var to items?  Or do this via mixins?
-- weaponry[item].designated_weapon = true 

--[[
--- PROJECTILE
--]]

-------------------------------------------------------------------

local Pistol = class('Pistol', ItemBase)

Pistol.FULL_NAME = 'pistol'
Pistol.WEIGHT = 6
Pistol.DURABILITY = 40
Pistol.MASTER_SKILL = 'light_guns'
Pistol.CATEGORY = 'military'

-------------------------------------------------------------------

local Magnum = class('Magnum', ItemBase)

Magnum.FULL_NAME = 'magnum'
Magnum.WEIGHT = 6
Magnum.DURABILITY = 50
Magnum.MASTER_SKILL = 'light_guns'
Magnum.CATEGORY = 'military'

-------------------------------------------------------------------

local Shotgun = class('Shotgun', ItemBase)

Shotgun.FULL_NAME = 'shotgun'
Shotgun.WEIGHT = 10
Shotgun.DURABILITY = 40
Shotgun.MASTER_SKILL = 'heavy_guns'
Shotgun.CATEGORY = 'military'

-------------------------------------------------------------------

local Rifle = class('Rifle', ItemBase)

Rifle.FULL_NAME = 'assualt rifle'
Rifle.WEIGHT = 15
Rifle.DURABILITY = 40
Rifle.MASTER_SKILL = 'heavy_guns'
Rifle.CATEGORY = 'military'

-------------------------------------------------------------------

local Flare = class('Flare', ItemBase)

Flare.FULL_NAME = 'flare'
Flare.WEIGHT = 5
Flare.DURABILITY = 0
Flare.MASTER_SKILL = 'explosives'
Flare.CATEGORY = 'military'

function Flare.client_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

function Flare.server_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

local flare_ranges = {6, 9, 12, 15}

function Flare.activate(player, condition)
  local y, x = player:getPos()
  local tile = player:getTile()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  -- Groan point of orgin
  local self_msg =   'You fire a flare into the sky.'
  local nearby_msg = '{player} fires a flare into the sky.'
  local msg =        'A flare was fired {pos}.'
  
  local words = {player=player, pos='{'..y..', '..x..'}'}
  nearby_msg = nearby_msg:replace(words)
  msg =               msg:replace(words)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'flare', player} -- (y, x, range) include this later?  We can use sound effects when this event is triggered based on distances
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(nearby_msg, self_msg, event)
  
  local settings = {stage='inside', exclude={}} -- broadcast to players on the same tile that are inside  
  tile:broadcastEvent(msg, event, settings) 
  
  settings.stage = nil
  settings.range = flare_ranges[condition]
  settings.exclude[tile] = true
  tile:broadcastEvent(msg, event, settings)     -- broadcast using a range and exclude the tile
end

-------------------------------------------------------------------

local Molotov = class('Molotov', ItemBase)

Molotov.FULL_NAME = 'molotov cocktail'
Molotov.WEIGHT = 5
Molotov.DURABILITY = 0
Molotov.MASTER_SKILL = 'explosives'
Molotov.CATEGORY = 'military'

-------------------------------------------------------------------

--[[
bow = {}
bow.FULL_NAME = 'bow'
bow.WEIGHT = 9

missle = {}
missle.FULL_NAME = 'missle launcher'
missle.WEIGHT = 25
--]]

return {Pistol, Magnum, Shotgun, Rifle, Flare, Molotov}