local weaponry = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  designated_weapon = true/nil 
  class_category = military/research/engineering/medical
  
==(not sure about these bottom ones?  code rewrite)==

  condition_omitted = nil/true  (if omitted, item has no condition levels)  
  special = nil/4/8/16  (bit_flags for special) [radio_freq, ammo, color, battery_life, etc.]  
--]]

--[[
---  BRUTE
--]]

weaponry.crowbar = {}
weaponry.crowbar.full_name = 'crowbar'
weaponry.crowbar.weight = 8

weaponry.toolbox = {}
weaponry.toolbox.full_name = 'toolbox'
weaponry.toolbox.weight = 15

weaponry.bat = {}
weaponry.bat.full_name = 'baseball bat'
weaponry.bat.weight = 9

weaponry.sledge = {}
weaponry.sledge.full_name = 'sledgehammer'
weaponry.sledge.weight = 25

--[[
---  BLADE
--]]

weaponry.knife = {}
weaponry.knife.full_name = 'knife'
weaponry.knife.weight = 3

weaponry.katanna = {}
weaponry.katanna.full_name = 'katanna'
weaponry.katanna.weight = 7

--[[
--- PROJECTILE
--]]

weaponry.pistol = {}
weaponry.pistol.full_name = 'pistol'
weaponry.pistol.weight = 6
weaponry.pistol.special = 16

weaponry.magnum = {}
weaponry.magnum.full_name = 'magnum'
weaponry.magnum.weight = 6
weaponry.magnum.special = 8

weaponry.shotgun = {}
weaponry.shotgun.full_name = 'shotgun'
weaponry.shotgun.weight = 10
weaponry.shotgun.special = 4

weaponry.flare = {}
weaponry.flare.full_name = 'flare'
weaponry.flare.weight = 5

weaponry.rifle = {}
weaponry.rifle.full_name = 'assualt rifle'
weaponry.rifle.weight = 15
weaponry.rifle.special = 8

weaponry.bow = {}
weaponry.bow.full_name = 'bow'
weaponry.bow.weight = 9
weaponry.bow.special = 8

weaponry.missle = {}
weaponry.missle.full_name = 'missle launcher'
weaponry.missle.weight = 25

weaponry.molotov = {}
weaponry.molotov.full_name = 'molotov cocktail'
weaponry.molotov.weight = 5

for item in pairs(weaponry) do 
  weaponry[item].designated_weapon = true 
  weaponry[item].class_category = 'military'
end

return weaponry