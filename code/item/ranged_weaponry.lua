local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
local IsWeapon =       require('code.item.mixin.is_weapon')
string.replace =       require('code.libs.replace')

-- need to add designated_weapon var to items?  Or do this via mixins?
-- weaponry[item].designated_weapon = true 

--[[
--- PROJECTILE
--]]

-------------------------------------------------------------------

local Pistol = class('Pistol', ItemBase):include(IsWeapon)

Pistol.FULL_NAME = 'pistol'
Pistol.WEIGHT = 6
Pistol.DURABILITY = 40
Pistol.CATEGORY = 'military'

Pistol.weapon = {
  ATTACK_STYLE = 'ranged',
  DAMAGE_TYPE = 'bullet',
  GROUP = {'guns', 'light_guns'},
  DICE = '1d6+2',
  ACCURACY = 0.30,
  CRITICAL = 0.05,
  MASTER_SKILL = 'light_guns',
}

Pistol.MAX_AMMO = 14
Pistol.RELOAD_AMOUNT = 14

-------------------------------------------------------------------

local Magnum = class('Magnum', ItemBase):include(IsWeapon)

Magnum.FULL_NAME = 'magnum'
Magnum.WEIGHT = 6
Magnum.DURABILITY = 50
Magnum.CATEGORY = 'military'

Magnum.weapon = {
  ATTACK_STYLE = 'ranged',
  DAMAGE_TYPE = 'bullet',
  GROUP = {'guns', 'light_guns'},
  DICE = '1d9+4',
  ACCURACY = 0.30,
  CRITICAL = 0.05,
  MASTER_SKILL = 'light_guns',
}

Magnum.MAX_AMMO = 6
Magnum.RELOAD_AMOUNT = 6

-------------------------------------------------------------------

local Shotgun = class('Shotgun', ItemBase):include(IsWeapon)

Shotgun.FULL_NAME = 'shotgun'
Shotgun.WEIGHT = 10
Shotgun.DURABILITY = 40
Shotgun.CATEGORY = 'military'

Shotgun.weapon = {
  ATTACK_STYLE = 'ranged',
  DAMAGE_TYPE = 'bullet',
  GROUP = {'guns', 'heavy_guns'},
  DICE = '3d3++1',
  ACCURACY = 0.30,
  CRITICAL = 0.05,
  MASTER_SKILL = 'heavy_guns',
}

Shotgun.MAX_AMMO = 2
Shotgun.RELOAD_AMOUNT = 1

-------------------------------------------------------------------

local Rifle = class('Rifle', ItemBase):include(IsWeapon)

Rifle.FULL_NAME = 'assualt rifle'
Rifle.WEIGHT = 15
Rifle.DURABILITY = 40
Rifle.CATEGORY = 'military'

Rifle.weapon = {
  ATTACK_STYLE = 'ranged',
  DAMAGE_TYPE = 'bullet',
  GROUP = {'guns', 'heavy_guns'},
  DICE = '(1d5)x3',
  ACCURACY = 0.30,
  CRITICAL = 0.05,
  MASTER_SKILL = 'heavy_guns',
}

Rifle.MAX_AMMO = 5
Rifle.RELOAD_AMOUNT = 5

-------------------------------------------------------------------

local Flare = class('Flare', ItemBase):include(IsWeapon)

Flare.FULL_NAME = 'flare'
Flare.WEIGHT = 5
Flare.DURABILITY = 0
Flare.CATEGORY = 'military'

Flare.weapon = {
  ATTACK_STYLE = 'ranged',
  DAMAGE_TYPE = 'scorch',
  GROUP = {'guns'},  -- really?!
  DICE = '5d3',
  ACCURACY = 0.15,
  CRITICAL = 0.30,
  MASTER_SKILL = 'explosives',
  --combustion_source = true,
  --fuel_amount = {'1d2+3', '1d3+5', '1d4+8', '1d5+10'},
}

function Flare:client_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

function Flare:server_criteria(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

local flare_ranges = {6, 9, 12, 15}

function Flare:activate(player)
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
  settings.range = flare_ranges[self.condition]
  settings.exclude[tile] = true
  tile:broadcastEvent(msg, event, settings)     -- broadcast using a range and exclude the tile
end

-------------------------------------------------------------------

local Molotov = class('Molotov', ItemBase):include(IsWeapon)

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