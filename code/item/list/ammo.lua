local ammo = {}

--[[
  full_name = 'insert name'
  weight = num
  class_category = 'military'
  durability = 0/1/+num    [0 = one use, 1 = one usage each time, +num = 1/num chance of usage]
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
  ammo[item].durability = 0  -- all ammo is single use
end

return ammo