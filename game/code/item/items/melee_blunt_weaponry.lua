local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsWeapon = require('code.item.mixin.is_weapon')

-------------------------------------------------------------------

--[[
---  BRUTE
--]]

-------------------------------------------------------------------

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

local Wrench = class('Wrench', Item):include(IsWeapon)

Wrench.FULL_NAME = 'wrench'
Wrench.WEIGHT = 9
Wrench.DURABILITY = 30
Wrench.CATEGORY = 'military'

Wrench.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d4',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

local Pipe = class('Pipe', Item):include(IsWeapon)

Pipe.FULL_NAME = 'metal pipe'
Pipe.WEIGHT = 7
Pipe.DURABILITY = 20
Pipe.CATEGORY = 'military'

Pipe.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d4',
  ACCURACY = 0.20,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

local Poolstick = class('Poolstick', Item):include(IsWeapon)

Poolstick.FULL_NAME = 'pool cue'
Poolstick.WEIGHT = 6
Poolstick.DURABILITY = 10
Poolstick.CATEGORY = 'military'

Poolstick.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d5',
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

local Rake = class('Rake', Item):include(IsWeapon)

Rake.FULL_NAME = 'shovel'
Rake.WEIGHT = 12
Rake.DURABILITY = 15
Rake.CATEGORY = 'military'

Rake.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d6',
  ACCURACY = 0.25,
  CRITICAL = 0.05,
  MASTER_SKILL = 'blunt_adv',
}

-------------------------------------------------------------------

local Shovel = class('Shovel', Item):include(IsWeapon)

Shovel.FULL_NAME = 'shovel'
Shovel.WEIGHT = 12
Shovel.DURABILITY = 15
Shovel.CATEGORY = 'military'

Shovel.weapon = {
  ATTACK_STYLE = 'melee',
  DAMAGE_TYPE = 'blunt',
  GROUP = {'brute'},
  DICE = '1d6',
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
  ACCURACY = 0.20,
  CRITICAL = 0.025,
  MASTER_SKILL = 'blunt_adv',
}

return {Crowbar, Wrench, Pipe, Poolstick, Bat, Rake, Shovel, Sledge}