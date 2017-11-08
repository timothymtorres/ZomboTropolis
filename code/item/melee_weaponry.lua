local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
local IsWeapon =       require('code.mixin.is_weapon')
string.replace =       require('code.libs.replace')

-- need to add designated_weapon var to items?  Or do this via mixins?
-- weaponry[item].designated_weapon = true 

-------------------------------------------------------------------

--[[
---  BRUTE
--]]

local Crowbar = class('Crowbar', ItemBase):include(IsWeapon)

Crowbar.FULL_NAME = 'crowbar'
Crowbar.WEIGHT = 8
Crowbar.DURABILITY = 25
Crowbar.CATEGORY = 'military'

Crowbar.ATTACK_STYLE = 'melee'
Crowbar.DAMAGE_TYPE = 'blunt'
Crowbar.GROUP = {'brute', 'light_brute'}
Crowbar.DICE = '1d4'
Crowbar.ACCURACY = 0.25
Crowbar.CRITICAL = 0.05

-------------------------------------------------------------------

local Bat = class('Bat', ItemBase):include(IsWeapon)

Bat.FULL_NAME = 'baseball bat'
Bat.WEIGHT = 9
Bat.DURABILITY = 15
Bat.CATEGORY = 'military'

Bat.ATTACK_STYLE = 'melee'
Bat.DAMAGE_TYPE = 'blunt'
Bat.GROUP = {'brute', 'light_brute'}
Bat.DICE = '1d5'
Bat.ACCURACY = 0.25
Bat.CRITICAL = 0.05
Bat.MASTER_SKILL = 'smacking'

-------------------------------------------------------------------

local Sledge = class('Sledge', ItemBase):include(IsWeapon)

Sledge.FULL_NAME = 'sledgehammer'
Sledge.WEIGHT = 25
Sledge.DURABILITY = 20
Sledge.CATEGORY = 'military'

Sledge.ATTACK_STYLE = 'melee'
Sledge.DAMAGE_TYPE = 'blunt'
Sledge.GROUP = {'brute', 'heavy_brute'}
Sledge.DICE = '1d8'
Sledge.ACCURACY = 0.25
Sledge.CRITICAL = 0.025
Sledge.MASTER_SKILL = 'smashing'

-------------------------------------------------------------------

--[[
---  BLADE
--]]

-------------------------------------------------------------------

local Knife = class('Knife', ItemBase):include(IsWeapon)

Knife.FULL_NAME = 'knife'
Knife.WEIGHT = 3
Knife.DURABILITY = 10
Knife.CATEGORY = 'military'

Knife.ATTACK_STYLE = 'melee'
Knife.DAMAGE_TYPE = 'pierce'
Knife.GROUP = {'blade', 'light_blade'}
Knife.DICE = '1d2+1'
Knife.ACCURACY = 0.25
Knife.CRITICAL = 0.075
Knife.MASTER_SKILL = 'slicing'

-------------------------------------------------------------------

local Katanna = class('Katanna', ItemBase):include(IsWeapon)

Katanna.FULL_NAME = 'katanna'
Katanna.WEIGHT = 7
Katanna.DURABILITY = 15
Katanna.CATEGORY = 'military'

Katanna.ATTACK_STYLE = 'melee'
Katanna.DAMAGE_TYPE = 'pierce'
Katanna.GROUP = {'blade', 'heavy_blade'}
Katanna.DICE = '1d4+2'
Katanna.ACCURACY = 0.25
Katanna.CRITICAL = 0.10
Katanna.MASTER_SKILL = 'chopping'

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