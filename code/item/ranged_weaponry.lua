local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
local isWeapon =       require('code.mixin.is_weapon')
string.replace =       require('code.libs.replace')

-- need to add designated_weapon var to items?  Or do this via mixins?
-- weaponry[item].designated_weapon = true 

--[[
--- PROJECTILE
--]]

-------------------------------------------------------------------

local Pistol = class('Pistol', ItemBase):include(isWeapon)

Pistol.FULL_NAME = 'pistol'
Pistol.WEIGHT = 6
Pistol.DURABILITY = 40
Pistol.MASTER_SKILL = 'light_guns'
Pistol.CATEGORY = 'military'

Pistol.ATTACK_STYLE = 'ranged'
Pistol.DAMAGE_TYPE = 'bullet'
Pistol.GROUP = {'guns', 'light_guns'}
Pistol.DICE = '1d6+2'
Pistol.ACCURACY = 0.30
Pistol.CRITICAL = 0.05

Pistol.MAX_AMMO = 14
Pistol.RELOAD_AMOUNT = 14

-------------------------------------------------------------------

local Magnum = class('Magnum', ItemBase):include(isWeapon)

Magnum.FULL_NAME = 'magnum'
Magnum.WEIGHT = 6
Magnum.DURABILITY = 50
Magnum.MASTER_SKILL = 'light_guns'
Magnum.CATEGORY = 'military'

Magnum.ATTACK_STYLE = 'ranged'
Magnum.DAMAGE_TYPE = 'bullet'
Magnum.GROUP = {'guns', 'light_guns'}
Magnum.DICE = '1d9+4'
Magnum.ACCURACY = 0.30
Magnum.CRITICAL = 0.05

Magnum.MAX_AMMO = 6
Magnum.RELOAD_AMOUNT = 6

-------------------------------------------------------------------

local Shotgun = class('Shotgun', ItemBase):include(isWeapon)

Shotgun.FULL_NAME = 'shotgun'
Shotgun.WEIGHT = 10
Shotgun.DURABILITY = 40
Shotgun.MASTER_SKILL = 'heavy_guns'
Shotgun.CATEGORY = 'military'

Shotgun.ATTACK_STYLE = 'ranged'
Shotgun.DAMAGE_TYPE = 'bullet'
Shotgun.GROUP = {'guns', 'heavy_guns'}
Shotgun.DICE = '3d3++1'
Shotgun.ACCURACY = 0.30
Shotgun.CRITICAL = 0.05

Shotgun.MAX_AMMO = 2
Shotgun.RELOAD_AMOUNT = 1

-------------------------------------------------------------------

local Rifle = class('Rifle', ItemBase):include(isWeapon)

Rifle.FULL_NAME = 'assualt rifle'
Rifle.WEIGHT = 15
Rifle.DURABILITY = 40
Rifle.MASTER_SKILL = 'heavy_guns'
Rifle.CATEGORY = 'military'

Rifle.ATTACK_STYLE = 'ranged'
Rifle.DAMAGE_TYPE = 'bullet'
Rifle.GROUP = {'guns', 'heavy_guns'}
Rifle.DICE = '(1d5)x3'
Rifle.ACCURACY = 0.30
Rifle.CRITICAL = 0.05

Rifle.MAX_AMMO = 5
Rifle.RELOAD_AMOUNT = 5

-------------------------------------------------------------------

local Flare = class('Flare', ItemBase):include(isWeapon)

Flare.FULL_NAME = 'flare'
Flare.WEIGHT = 5
Flare.DURABILITY = 0
Flare.MASTER_SKILL = 'explosives'
Flare.CATEGORY = 'military'

Flare.ATTACK_STYLE = 'ranged'
Flare.DAMAGE_TYPE = 'scorch'
Flare.GROUP = {'guns'}  -- really?!
Flare.DICE = '5d3'
Flare.ACCURACY = 0.15
Flare.CRITICAL = 0.30
--Flare.combustion_source = true
--Flare.fuel_amount = {'1d2+3', '1d3+5', '1d4+8', '1d5+10'}

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

local Molotov = class('Molotov', ItemBase):include(isWeapon)

Molotov.FULL_NAME = 'molotov cocktail'
Molotov.WEIGHT = 5
Molotov.DURABILITY = 0
Molotov.MASTER_SKILL = 'explosives'
Molotov.CATEGORY = 'military'

Molotov.ATTACK_STYLE = 'ranged'
Molotov.DAMAGE_TYPE = 'scorch'
Molotov.GROUP = {'special'}
Molotov.DICE = '5d2'
Molotov.ACCURACY = 0.20
Molotov.CRITICAL = 0.30
--Molotov.combustion_source = true
--Molotov.fuel_amount = {'1d5+10', '1d7+12', '1d9+14', '2d5+15'}

-------------------------------------------------------------------

--[[
bow = {}
bow.FULL_NAME = 'bow'
bow.WEIGHT = 9

missle = {}
missle.FULL_NAME = 'missle launcher'
missle.WEIGHT = 25

weapon.missile = {}
weapon.missile.full_name = 'missile launcher'
weapon.missile.attack_style = 'ranged'
weapon.missile.damage_type = 'scorch'
weapon.missile.group = {'special'}
weapon.missile.dice = '5d8'
weapon.missile.accuracy = 0.15
weapon.missile.critical = 0.30
weapon.missile.one_use = true

bow/crossbow
--]]

return {Pistol, Magnum, Shotgun, Rifle, Flare, Molotov}