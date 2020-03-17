local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsWeapon = require('code.item.mixin.is_weapon')

-------------------------------------------------------------------

--[[
---  BLADE
--]]

-------------------------------------------------------------------

local Knife = class('Knife', Item):include(IsWeapon)

Knife.FULL_NAME = 'knife'
Knife.WEIGHT = 3
Knife.DURABILITY = 8
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

--------------------------------------------------------------------

local Pitchfork = class('Pitchfork', Item):include(IsWeapon)

Pitchfork.FULL_NAME = 'pitchfork'
Pitchfork.WEIGHT = 12
Pitchfork.DURABILITY = 15
Pitchfork.CATEGORY = 'military'

Pitchfork.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'pierce',
  GROUP = {'cut'},
  DICE = '1d3+1',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blade_adv',
}

-------------------------------------------------------------------

local Axe = class('Axe', Item):include(IsWeapon)

Axe.FULL_NAME = 'fire axe'
Axe.WEIGHT = 15
Axe.DURABILITY = 20
Axe.CATEGORY = 'military'

Axe.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'pierce',
  GROUP = {'cut'},
  DICE = '1d4+1',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blade_adv',
}

--------------------------------------------------------------------

local Pickaxe = class('Pickaxe', Item):include(IsWeapon)

Pickaxe.FULL_NAME = 'pickaxe'
Pickaxe.WEIGHT = 17
Pickaxe.DURABILITY = 25
Pickaxe.CATEGORY = 'military'

Pickaxe.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'pierce',
  GROUP = {'cut'},
  DICE = '1d4+1',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blade_adv',
}

--------------------------------------------------------------------

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

return {Knife, Pitchfork, Axe, Pickaxe, Katanna}