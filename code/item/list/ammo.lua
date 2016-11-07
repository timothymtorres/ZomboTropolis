local ammo = {}

--[[
  full_name = 'insert name'
  weight = num
  class_category = 'military'
  one_use = true
--]]

ammo.pistol_mag = {}
ammo.pistol_mag.full_name = 'pistol magazine'
ammo.pistol_mag.weight = 3

ammo.shotgun_shell = {}
ammo.shotgun_shell.full_name = 'shotgun shell'
ammo.shotgun_shell.weight = 2

ammo.rifle_clip = {}
ammo.rifle_clip.full_name = 'rifle clip'
ammo.rifle_clip.weight = 5

ammo.quiver = {}
ammo.quiver.full_name = 'quiver'
ammo.quiver.weight = 4

for item in pairs(ammo) do 
  ammo[item].class_category = 'military' 
  ammo[item].one_use = true  -- all ammo is single use
end

return ammo