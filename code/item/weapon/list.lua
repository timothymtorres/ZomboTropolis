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

--[[
---  BRUTE
--]]

weapon.crowbar = {}
weapon.crowbar.full_name = 'crowbar'
weapon.crowbar.attack_style = 'melee'
weapon.crowbar.damage_type = 'blunt'
weapon.crowbar.group = {'brute', 'light_brute'}
weapon.crowbar.dice = '1d4'
weapon.crowbar.accuracy = 0.25
weapon.crowbar.critical = 0.05
weapon.crowbar.object_damage = {barricade=2, door=1, equipment=1}
weapon.crowbar.master_skill = 'smacking'

weapon.toolbox = {}
weapon.toolbox.full_name = 'toolbox'
weapon.toolbox.attack_style = 'melee'
weapon.toolbox.damage_type = 'blunt'
weapon.toolbox.group = {'brute', 'heavy_brute'}
weapon.toolbox.dice = '1d4'
weapon.toolbox.accuracy = 0.20
weapon.toolbox.critical = 0.05
weapon.toolbox.master_skill = 'smashing'

weapon.bat = {}
weapon.bat.full_name = 'baseball bat'
weapon.bat.attack_style = 'melee'
weapon.bat.damage_type = 'blunt'
weapon.bat.group = {'brute', 'light_brute'}
weapon.bat.dice = '1d5'
weapon.bat.accuracy = 0.25
weapon.bat.critical = 0.05
weapon.bat.master_skill = 'smacking'

weapon.sledge = {}
weapon.sledge.full_name = 'sledgehammer'
weapon.sledge.attack_style = 'melee'
weapon.sledge.damage_type = 'blunt'
weapon.sledge.group = {'brute', 'heavy_brute'}
weapon.sledge.dice = '1d8'
weapon.sledge.accuracy = 0.25
weapon.sledge.critical = 0.025
weapon.sledge.object_damage = {barricade=1, door=1, equipment=1}
weapon.sledge.master_skill = 'smashing'

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

--[[
---  BLADE
--]]

weapon.knife = {}
weapon.knife.full_name = 'knife'
weapon.knife.attack_style = 'melee'
weapon.knife.damage_type = 'pierce'
weapon.knife.group = {'blade', 'light_blade'}
weapon.knife.dice = '1d2+1'
weapon.knife.accuracy = 0.25
weapon.knife.critical = 0.075
weapon.knife.object_damage = {barricade=1, door=1, equipment=1}
weapon.knife.master_skill = 'slicing'

weapon.katanna = {}
weapon.katanna.full_name = 'katanna'
weapon.katanna.attack_style = 'melee'
weapon.katanna.damage_type = 'pierce'
weapon.katanna.group = {'blade', 'heavy_blade'}
weapon.katanna.dice = '1d4+2'
weapon.katanna.accuracy = 0.25
weapon.katanna.critical = 0.10
weapon.katanna.object_damage = {barricade=1, door=1, equipment=1}
weapon.katanna.master_skill = 'chopping'

--weapon.axe  ???

--[[
--- PROJECTILE
--]]

weapon.pistol = {}
weapon.pistol.full_name = 'pistol'
weapon.pistol.attack_style = 'ranged'
weapon.pistol.damage_type = 'bullet'
weapon.pistol.group = {'guns', 'light_guns'}
weapon.pistol.dice = '1d6+2'
weapon.pistol.accuracy = 0.30
weapon.pistol.critical = 0.05
weapon.pistol.max_ammo = 14
weapon.pistol.reload_amount = 14

weapon.magnum = {}
weapon.magnum.full_name = 'magnum'
weapon.magnum.attack_style = 'ranged'
weapon.magnum.damage_type = 'bullet'
weapon.magnum.group = {'guns', 'light_guns'}
weapon.magnum.dice = '1d9+4'
weapon.magnum.accuracy = 0.30
weapon.magnum.critical = 0.05
weapon.magnum.max_ammo = 6
weapon.magnum.reload_amount = 6

weapon.shotgun = {}
weapon.shotgun.full_name = 'shotgun'
weapon.shotgun.attack_style = 'ranged'
weapon.shotgun.damage_type = 'bullet'
weapon.shotgun.group = {'guns', 'heavy_guns'}
weapon.shotgun.dice = '3d3++1'
weapon.shotgun.accuracy = 0.30
weapon.shotgun.critical = 0.05
weapon.shotgun.max_ammo = 2
weapon.shotgun.reload_amount = 1

--[[
--- BURN
--]]

weapon.molotov = {}
weapon.molotov.full_name = 'molotov cocktail'
weapon.molotov.attack_style = 'ranged'
weapon.molotov.damage_type = 'scorch'
weapon.molotov.group = {'special'}
weapon.molotov.dice = '5d2'
weapon.molotov.accuracy = 0.20
weapon.molotov.critical = 0.30
weapon.molotov.one_use = true
weapon.molotov.combustion_source = true
weapon.molotov.fuel_amount = {'1d5+10', '1d7+12', '1d9+14', '2d5+15'}

weapon.flare = {}
weapon.flare.full_name = 'flare gun'
weapon.flare.attack_style = 'ranged'
weapon.flare.damage_type = 'scorch'
weapon.flare.group = {'guns'}  -- really?!
weapon.flare.dice = '5d3'
weapon.flare.accuracy = 0.15
weapon.flare.critical = 0.30
weapon.flare.one_use = true
weapon.flare.combustion_source = true
weapon.flare.fuel_amount = {'1d2+3', '1d3+5', '1d4+8', '1d5+10'}

weapon.missile = {}
weapon.missile.full_name = 'missile launcher'
weapon.missile.attack_style = 'ranged'
weapon.missile.damage_type = 'scorch'
weapon.missile.group = {'special'}
weapon.missile.dice = '5d8'
weapon.missile.accuracy = 0.15
weapon.missile.critical = 0.30
weapon.missile.one_use = true

--[[
weapon.rifle = class('rifle', weapon)
weapon.rifle.full_name = 'assualt rifle'
weapon.rifle.attack_style = 'ranged'
weapon.rifle.damage_type = 'bullet'
weapon.rifle.group = 'rifle'

bow/crossbow
--]]

--[[
--- MISC
--]]

weapon.newspaper = {}
weapon.newspaper.full_name = 'newspaper'
weapon.newspaper.accuracy = 1.00
weapon.newspaper.no_damage = true
weapon.newspaper.one_use = true



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

weapon.bite = {}
weapon.bite.full_name = 'bite'
weapon.bite.attack_style = 'melee'
weapon.bite.damage_type = 'pierce'
weapon.bite.group = {'teeth'}
weapon.bite.dice = '1d4+1'
weapon.bite.accuracy = 0.20
weapon.bite.critical = 0.05
weapon.bite.organic = 'zombie'

--[[
--- PROJECTILE
--]]

weapon.sting = {}
weapon.sting.full_name = 'sting'
weapon.sting.attack_style = 'ranged'
weapon.sting.damage_type = 'bullet'
weapon.sting.group = {'stinger'}
weapon.sting.dice = '1d2'
weapon.sting.accuracy = 0.15
weapon.sting.critical = 0.05
weapon.sting.organic = 'zombie'
weapon.sting.condition_effect = 'poison'
weapon.sting.skill_required = 'stinger'

--[[
--- BURN
--]]

weapon.acid = {}
weapon.acid.full_name = 'stomach acid'
weapon.acid.attack_style = 'ranged'
weapon.acid.damage_type = 'scorch'
weapon.acid.group = {'stomach'}
weapon.acid.dice = '5d2'
weapon.acid.accuracy = 0.15
weapon.acid.critical = 0.30
weapon.acid.organic = 'zombie'

return weapon