local dice = require('code.libs.dice')
local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsArmor = require('code.item.mixin.is_armor')

-------------------------------------------------------------------

local Scale = class('Scale', Item):include(IsArmor)
OrganicArmor.list[#OrganicArmor.list+1] = 'Scale'

Scale.FULL_NAME = 'scale'
Scale.DURABILITY = 8

Scale.armor = {}
Scale.armor.resistance = {
  {bullet=1,          pierce=1},
  {bullet=2, blunt=1, pierce=2},
  {bullet=3, blunt=2, pierce=3},
  {bullet=5, blunt=4, pierce=4},
}

-------------------------------------------------------------------

local Blubber = class('Blubber', Item):include(IsArmor)
OrganicArmor.list[#OrganicArmor.list+1] = 'Blubber'

Blubber.FULL_NAME = 'blubber'
Blubber.DURABILITY = 16

Blubber.armor = {}
Blubber.armor.resistance = {
  {          blunt=1, pierce=1},
  {bullet=1, blunt=1, pierce=1},  
  {bullet=1, blunt=1, pierce=2},
  {bullet=2, blunt=1, pierce=2},
}

------------------------- ------------------------------------------

local Gel = class('Gel', Item):include(IsArmor)
OrganicArmor.list[#OrganicArmor.list+1] = 'Gel'

Gel.FULL_NAME = 'gel'
Gel.DURABILITY = 32

Gel.armor = {}
Gel.armor.resistance = {
  {          blunt=1, pierce=1, scorch=4},
  {          blunt=1, pierce=1, scorch=4},
  {bullet=1, blunt=1, pierce=1, scorch=4},
  {bullet=1, blunt=1, pierce=1, scorch=4},
}

-------------------------------------------------------------------

local Bone = class('Bone', Item):include(IsArmor)
OrganicArmor.list[#OrganicArmor.list+1] = 'Bone'

Bone.FULL_NAME = 'bone'
Bone.DURABILITY = 8

Bone.armor = {}
Bone.armor.resistance = {
  {damage_melee_attacker=1},
  {damage_melee_attacker=1},
  {damage_melee_attacker=1},
  {damage_melee_attacker=2},      
}

-------------------------------------------------------------------

--[[
local Stretch = class('Stretch', OrganicArmor)

Stretch.FULL_NAME = 'stretch'
Stretch.DURABILITY = 8
Stretch.armor.resistance = {
  {bullet=1}
}
--]]

-------------------------------------------------------------------

return {Scale, Blubber, Gel, Bone} -- Stretch,}