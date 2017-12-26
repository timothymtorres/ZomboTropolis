local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsArmor = require('code.item.mixin.is_armor')

-------------------------------------------------------------------

local OrganicArmor = class('OrganicArmor', Item):include(IsArmor)  -- remove Item superclass... do we need the methods?
OrganicArmor.ap = {cost = 5, modifier={armor_adv = -2}}

function OrganicArmor:client_criteria(player)
	assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')
	-- add feed/corpse asserts here
end

function OrganicArmor:server_criteria(player, armor)
	assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')
  assert(not armor or player.skills:check('armor_adv'), 'Must have "armor_adv" skill to select armor')  
	-- add feed/corpse asserts here
end

function OrganicArmor:activate(player)
  -- run feed/corpse code
  -- init armor obj
  -- give armor obj condition?

  player.equipment:add('armor', self)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You mutate a corpse and gain a {armor}.'
  msg = msg:replace(self) -- This should work? Needs to be tested

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'armor', player}  
  player.log:insert(msg, event)  
end

-------------------------------------------------------------------

local Scale = class('Scale', OrganicArmor)

Scale.FULL_NAME = 'scale'
Scale.DURABILITY = 8

Scale.armor.resistance = {
  {bullet=1,          pierce=1},
  {bullet=2, blunt=1, pierce=2},
  {bullet=3, blunt=2, pierce=3},
  {bullet=5, blunt=4, pierce=4},
}

-------------------------------------------------------------------

local Blubber = class('Blubber', OrganicArmor)

Blubber.FULL_NAME = 'firesuit'
Blubber.DURABILITY = 16

Blubber.armor.resistance = {
  {          blunt=1, pierce=1},
  {bullet=1, blunt=1, pierce=1},  
  {bullet=1, blunt=1, pierce=2},
  {bullet=2, blunt=1, pierce=2},
}

------------------------- ------------------------------------------

local Gel = class('Gel', OrganicArmor)
{
Gel.FULL_NAME = 'gel'
Gel.DURABILITY = 32

Gel.armor.resistance = {
  {          blunt=1, pierce=1, scorch=4},
  {          blunt=1, pierce=1, scorch=4},
  {bullet=1, blunt=1, pierce=1, scorch=4},
  {bullet=1, blunt=1, pierce=1, scorch=4},
}

-------------------------------------------------------------------

local Bone = class('Bone', OrganicArmor)

Bone.FULL_NAME = 'bone'
Bone.DURABILITY = 8

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