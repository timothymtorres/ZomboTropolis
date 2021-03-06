local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsWeapon = require('code.item.mixin.is_weapon')

-------------------------------------------------------------------

--[[
---  BRUTE
--]]

local Crowbar = class('Crowbar', Item):include(IsWeapon)

Crowbar.FULL_NAME = 'crowbar'
Crowbar.WEIGHT = 8
Crowbar.DURABILITY = 25
Crowbar.CATEGORY = 'military'

Crowbar.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d4',
  ACCURACY = 0.25,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

local Bat = class('Bat', Item):include(IsWeapon)

Bat.FULL_NAME = 'baseball bat'
Bat.WEIGHT = 9
Bat.DURABILITY = 15
Bat.CATEGORY = 'military'

Bat.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d5',
  ACCURACY = 0.25,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

local Sledge = class('Sledge', Item):include(IsWeapon)

Sledge.FULL_NAME = 'sledgehammer'
Sledge.WEIGHT = 25
Sledge.DURABILITY = 20
Sledge.CATEGORY = 'military'

Sledge.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d8',
  ACCURACY = 0.25,
  CRITICAL = 0.025,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

--[[
---  BLADE
--]]

-------------------------------------------------------------------

local Knife = class('Knife', Item):include(IsWeapon)

Knife.FULL_NAME = 'knife'
Knife.WEIGHT = 3
Knife.DURABILITY = 10
Knife.CATEGORY = 'military'

Knife.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'pierce',
  GROUP = {'cut'},
  DICE = '1d2+1',
  ACCURACY = 0.25,
  CRITICAL = 0.075,
  MASTER_SKILL = 'blade_adv',
}

-------------------------------------------------------------------

local Katanna = class('Katanna', Item):include(IsWeapon)

Katanna.FULL_NAME = 'katanna'
Katanna.WEIGHT = 7
Katanna.DURABILITY = 15
Katanna.CATEGORY = 'military'

Katanna.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'pierce',
  GROUP = {'cut'},
  DICE = '1d4+2',
  ACCURACY = 0.25,
  CRITICAL = 0.10,
  MASTER_SKILL = 'blade_adv',
}

--------------------------------------------------------------------

-- axe? fireaxe?
--[[
weapon.fuel = {}
weapon.fuel.full_name = 'fuel tank'
weapon.fuel.attack_style = 'melee'
weapon.fuel.damage_type = 'blunt'
weapon.fuel.group = {'brute'}
weapon.fuel.dice = '1d3'
weapon.fuel.accuracy = 0.25
weapon.fuel.critical = 0.025
weapon.fuel.one_use = true
weapon.fuel.combustion_source = false
weapon.fuel.fuel_amount = {'1d5+10', '2d5+20', '3d5+30', '4d5+40'}
--]]

return {Crowbar, Bat, Sledge, Knife, Katanna}