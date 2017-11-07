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

Pistol.static = {
  FULL_NAME = 'pistol',
  WEIGHT = 6,
  DURABILITY = 40,  
  MASTER_SKILL = 'light_guns',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Magnum = class('Magnum', ItemBase)

Magnum.static = {
  FULL_NAME = 'magnum',
  WEIGHT = 6,
  DURABILITY = 50,  
  MASTER_SKILL = 'light_guns',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Shotgun = class('Shotgun', ItemBase)

Shotgun.static = {
  FULL_NAME = 'shotgun',
  WEIGHT = 10,
  DURABILITY = 40,  
  MASTER_SKILL = 'heavy_guns',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Rifle = class('Rifle', ItemBase)

Rifle.static = {
  FULL_NAME = 'assualt rifle',
  WEIGHT = 15,
  DURABILITY = 40,  
  MASTER_SKILL = 'heavy_guns',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Flare = class('Flare', ItemBase)

Flare.static = {
  FULL_NAME = 'flare',
  WEIGHT = 5,
  DURABILITY = 0,
  MASTER_SKILL = 'explosives',
  CATEGORY = 'military',
}

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

Molotov.static = {
  FULL_NAME = 'molotov cocktail',
  WEIGHT = 5,
  DURABILITY = 0,
  MASTER_SKILL = 'explosives',
  CATEGORY = 'military',
}

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