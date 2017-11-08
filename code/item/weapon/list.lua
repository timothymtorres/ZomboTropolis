local weapon = {}

--[[---------

  HUMAN WEAPONS

--]]---------


--[[
---  MELEE
--]]

weapon.fist = {}
weapon.fist.full_name = 'fist'
weapon.fist.attack_style = 'melee'
weapon.fist.damage_type = 'blunt'
weapon.fist.group = {'hand'}
weapon.fist.dice = '1d1'
weapon.fist.accuracy = 0.20
weapon.fist.critical = 0.05
weapon.fist.organic = 'human'
weapon.fist.master_skill = 'martial_arts_adv'

--[[---------

  ZOMBIE WEAPONS

--]]---------



--[[
---  MELEE
--]]

weapon.claw = {}
weapon.claw.full_name = 'claw'
weapon.claw.attack_style = 'melee'
weapon.claw.damage_type = 'blunt'
weapon.claw.group = {'arm'}
weapon.claw.dice = '1d3'
weapon.claw.accuracy = 0.99 --0.25
weapon.claw.critical = 0.05
weapon.claw.organic = 'zombie'
weapon.claw.object_damage = {barricade=1, door=1, equipment=1}
weapon.claw.condition_effect = 'entangle'
weapon.claw.master_skill = 'claw_adv'

weapon.bite = {}
weapon.bite.full_name = 'bite'
weapon.bite.attack_style = 'melee'
weapon.bite.damage_type = 'pierce'
weapon.bite.group = {'teeth'}
weapon.bite.dice = '1d4+1'
weapon.bite.accuracy = 0.20
weapon.bite.critical = 0.05
weapon.bite.organic = 'zombie'
weapon.bite.condition_effect = 'infection'
weapon.bite.master_skill = 'bite_adv'

--[[
--- BURN
--]]

--[[  Moved to skill activation
weapon.acid = {}
weapon.acid.full_name = 'stomach acid'
weapon.acid.attack_style = 'ranged'
weapon.acid.damage_type = 'scorch'
weapon.acid.group = {'stomach'}
weapon.acid.dice = '5d2'
weapon.acid.accuracy = 0.15
weapon.acid.critical = 0.30
weapon.acid.organic = 'zombie'
--]]

return weapon