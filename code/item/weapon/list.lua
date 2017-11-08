local weapon = {}

--[[
  {
    full_name = 'insert name'
    attack_style = melee/ranged
    damage_type = bullet/pierce/blunt/scorch
    group = {
      organic (arm/teeth/stomach)  
      melee (brute/blade)  
      firearms (gun/handgun/shotgun/rifle)  
      archery (bow/crossbow)
      misc. (special)
    }
    dice = '?d?'
    accuracy = 0.00 (base chance to hit)
    critical = 0.00 (base chance for crit)
    
    *if gun/bow*
    
    max_ammo = num
    reload_amount = num
    
    *optional*
    
    organic = human/zombie/nil (results in default weapon choice, since weapon is attached to body)
    object_damage = {barricade=1/2/nil, door=1/2/nil, equipment=1/2/nil} /nil
    master_skill = skill_name/nil (designated skill that signals mastery)
    one_use = true/nil (is disposed of after one use)
    ^^^^ if weapon is ranged immediately after firing it's used
    ^^^^ if weapon is melee then when a hit is landed it's used 
    no_damage = true/nil (does not cause damage)
    condition_effect = poison/infect/burn/confuse/blind/nil
    skill_required = skill_name/nil  (need a skill to use this weapon, mostly for special zombie attacks)
    fuel_amount = {num}/nil
    combustion_source = true/false/nil (can this weapon ignite a fire)
  } 
--]]

-- WEAPON CONDITION MODIFIERS (blunt = damage range, blade = damage bonus, bullet = to-hit-accuracy, scorch = damage rolls)

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