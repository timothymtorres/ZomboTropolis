local dice = require('code.libs.dice')
local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsArmor = require('code.item.mixin.is_armor')

-------------------------------------------------------------------

local OrganicArmor = class('OrganicArmor', Item):include(IsArmor)  -- remove Item superclass... do we need the methods?
OrganicArmor.ap = {cost = 5, modifier={armor_adv = -2}}
OrganicArmor.list = {}

function OrganicArmor:client_criteria(player)
	assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')

  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

function OrganicArmor:server_criteria(player, armor_type)
	assert(player.skills:check('armor'), 'Must have "armor" skill to create armor')
  assert(not armor_type or player.skills:check('armor_adv'), 'Must have "armor_adv" skill to select armor')  

  local p_tile = player:getTile()
  local p_stage = player:getStage()
  local corpses = p_tile:getCorpses(p_stage)
  assert(corpses, 'No available corpses to eat')
  
  local edible_corpse_present 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

function OrganicArmor:activate(player, armor_type)
  local corpses = p_tile:getCorpses(player:getStage())
  local target
  local lowest_scavenger_num = 4
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for corpse in pairs(corpses) do
    if corpse:isMobType('human') and corpse.carcass:edible(player) then
      local corpse_scavenger_num = #corpse.carcass.carnivour_list
      if lowest_scavenger_num > corpse_scavenger_num then
        target = corpse
        lowest_scavenger_num = corpse_scavenger_num 
      end
    end
  end

  local nutrition_LV = target.carcass:devour(player)
  local armor_dice = dice:new('1d'..nutrition_LV)

  if player.skills:check('armor_adv') then armor_dice = armor_dice ^ 1 end
  local condition = armor_dice:roll()

  armor_type = armor_type or OrganicArmor.list[math.random(1, #OrganicArmor.list)]
  armor = OrganicArmor.subclass[armor]:new(condition) -- This should work... 

  player.equipment:add('armor', armor)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'You mutate a corpse and gain a {armor}.'
  msg = msg:replace(self) -- This should work? Needs to be tested

--[[  Planning on redoing the armor code so these msgs will probably change  
  if armor_type == 'scale' then
    msg[1] = 'Your skin shapeshifts into hard scales that are resistant to bladed weapons.'  
  elseif armor_type == 'blubber' then
    msg[1] = 'Your body shapeshifts into a blubbery mass that is skilled at absorbing blunt weapon impacts.'
  elseif armor_type == 'gel' then
    msg[1] = 'Your body oozes goo out of various pores that is effective at absorbing heat.'
  elseif armor_type == 'sticky' then
    msg[1] = 'Your body secretes slime causing the various armor layers to become more resillent.'
  elseif armor_type == 'stretch' then
    msg[1] = 'Your skin becomes loose and rubbery causing projectiles to slow as they make contact.'
  end
--]]  

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'armor', player}  
  player.log:insert(msg, event)  
end

-------------------------------------------------------------------

local Scale = class('Scale', OrganicArmor)
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

local Blubber = class('Blubber', OrganicArmor)
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

local Gel = class('Gel', OrganicArmor)
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

local Bone = class('Bone', OrganicArmor)
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