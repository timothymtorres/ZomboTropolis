local ammo = {}

--[[
  full_name = 'insert name'
  weight = num
  class_category = 'military'
  condition_omitted = nil/true  (if omitted, item has no condition levels)
  special = nil/4/16  (bit_flags for special) [ammo, color, battery_life, etc.] 
--]]

ammo.pistol_mag = {}
ammo.pistol_mag.full_name = 'pistol magazine'
ammo.pistol_mag.weight = 3
ammo.pistol_mag.condition_omitted = true

ammo.shotgun_shell = {}
ammo.shotgun_shell.full_name = 'shotgun shell'
ammo.shotgun_shell.weight = 2
ammo.shotgun_shell.condition_omitted = true

ammo.rifle_clip = {}
ammo.rifle_clip.full_name = 'rifle clip'
ammo.rifle_clip.weight = 5
ammo.rifle_clip.condition_omitted = true

ammo.quiver = {}
ammo.quiver.full_name = 'quiver'
ammo.quiver.weight = 4
ammo.quiver.condition_omitted = true

for item in pairs(ammo) do ammo[item].class_category = 'military' end

return ammo