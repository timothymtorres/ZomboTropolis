local weaponry = {}

--[[
  full_name = 'insert name'
  weight = num
  designated_weapon = true/nil 
  class_category = military/research/engineering/medical
  one_use = true/nil
  durability = num (average # of attacks to wear out weapon)
--]]

--[[
---  BRUTE
--]]

weaponry.crowbar = {}
weaponry.crowbar.full_name = 'crowbar'
weaponry.crowbar.weight = 8
weaponry.crowbar.master_skill = 'smacking'
weaponry.crowbar.durability = 25

weaponry.bat = {}
weaponry.bat.full_name = 'baseball bat'
weaponry.bat.weight = 9
weaponry.bat.master_skill = 'smacking'
weaponry.bat.durability = 15

weaponry.toolbox = {}
weaponry.toolbox.full_name = 'toolbox'
weaponry.toolbox.weight = 15
weaponry.toolbox.master_skill = 'repair_adv'
weaponry.toolbox.durability = 10

weaponry.sledge = {}
weaponry.sledge.full_name = 'sledgehammer'
weaponry.sledge.weight = 25
weaponry.sledge.master_skill = 'smashing'
weaponry.sledge.durability = 20

--[[
---  BLADE
--]]

weaponry.knife = {}
weaponry.knife.full_name = 'knife'
weaponry.knife.weight = 3
weaponry.knife.master_skill = 'slicing'
weaponry.knife.durability = 10

weaponry.katanna = {}
weaponry.katanna.full_name = 'katanna'
weaponry.katanna.weight = 7
weaponry.katanna.master_skill = 'chopping'
weaponry.katanna.durability = 15

--[[
--- PROJECTILE
--]]

weaponry.pistol = {}
weaponry.pistol.full_name = 'pistol'
weaponry.pistol.weight = 6
weaponry.pistol.master_skill = 'light_guns'
weaponry.pistol.durability = 40

weaponry.magnum = {}
weaponry.magnum.full_name = 'magnum'
weaponry.magnum.weight = 6
weaponry.magnum.master_skill = 'light_guns'
weaponry.magnum.durability = 50

weaponry.shotgun = {}
weaponry.shotgun.full_name = 'shotgun'
weaponry.shotgun.weight = 10
weaponry.shotgun.master_skill = 'heavy_guns'
weaponry.shotgun.durability = 40

weaponry.rifle = {}
weaponry.rifle.full_name = 'assualt rifle'
weaponry.rifle.weight = 15
weaponry.rifle.master_skill = 'heavy_guns'
weaponry.rifle.durability = 40

--[[
weaponry.bow = {}
weaponry.bow.full_name = 'bow'
weaponry.bow.weight = 9

weaponry.missle = {}
weaponry.missle.full_name = 'missle launcher'
weaponry.missle.weight = 25
--]]

weaponry.flare = {}
weaponry.flare.full_name = 'flare'
weaponry.flare.weight = 5
weaponry.flare.durability = 0
weaponry.flare.master_skill = 'explosives'

weaponry.molotov = {}
weaponry.molotov.full_name = 'molotov cocktail'
weaponry.molotov.weight = 5
weaponry.molotov.durability = 0
weaponry.molotov.master_skill = 'explosives'

for item in pairs(weaponry) do 
  weaponry[item].designated_weapon = true 
  weaponry[item].class_category = 'military'
end

return weaponry