--[[
local weapon = require('code.item.weapon.class')

local weapon_list = {weapon.fist, weapon.bite, weapon.claw, weapon.crowbar, weapon.sledge, weapon.knife, weapon.katanna, weapon.pistol, weapon.shotgun}

for ID, obj in ipairs(weapon_list) do
  weapon_list[obj:getName()] = ID 
  obj.weapon_ID = ID
end

local function lookupWeapon(obj)
  local weap
  if type(obj) == 'string' then 
    local ID = weapon_list[obj]
    weap = weapon_list[ID]
  elseif type(obj) == 'number' then
    local ID = obj
    weap = weapon_list[ID]
  else
    error('item weapon_lookup invalid')
  end
  return weap
end

--for i,v in ipairs(weapon_list) do print(k,v) end

return lookupWeapon
--]]