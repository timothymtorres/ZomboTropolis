local error_list = require('code.error.list')

local criteria = {}

--[[
--- MEDICAL
--]]

error_list[#error_list+1] = 'Target has been killed'
error_list[#error_list+1] = 'Target is out of range'
error_list[#error_list+1] = 'Target has full health'
error_list[#error_list+1] = 'Target must be a human'

error_list[#error_list+1] = 'Target has been killed'
error_list[#error_list+1] = 'Target is out of range'
error_list[#error_list+1] = 'Target has full health'
error_list[#error_list+1] = 'Target must be a human'

error_list[#error_list+1] = 'Target has been killed'
error_list[#error_list+1] = 'Target is out of range'
error_list[#error_list+1] = 'Target must be a human'

error_list[#error_list+1] = 'Target has been killed'
error_list[#error_list+1] = 'Target is out of range'
error_list[#error_list+1] = 'Target must be a human'

error_list[#error_list+1] = 'Target has been killed'
error_list[#error_list+1] = 'Target is out of range'
error_list[#error_list+1] = 'Target must be a zombie'

--[[
--- WEAPONS
--]]

error_list[#error_list+1] = 'Player must be outside to use flare'

--[[
--- EQUIPMENT
--]]

error_list[#error_list+1] = 'Must be inside building to barricade'
error_list[#error_list+1] = 'There is no room available for fortifications'
error_list[#error_list+1] = 'Unable to make stronger fortification without required skills'
error_list[#error_list+1] = 'Unable to make fortifications in a ruined building'

error_list[#error_list+1] = 'Must be inside building to refuel'
error_list[#error_list+1] = 'Missing nearby generator to refuel'

error_list[#error_list+1] = 'Must be inside building to repair'
error_list[#error_list+1] = 'Unable to repair building in current state'  

--[[
--- JUNK
--]]

function criteria.book(player) end  -- need light?

function criteria.newspaper(player) end  -- need light?

function criteria.bottle(player) end

--[[
--- ARMOR
--]]

function criteria.leather(player) end  -- make sure there is inventory room when unequiping armor?

function criteria.firesuit(player) end

return criteria