local building = require('code.location.building.class')
local tile = require('code.location.tile.class')

local generator = require('code.location.building.equipment.generator.class')
local transmitter = require('code.location.building.equipment.transmitter.class')
local terminal = require('code.location.building.equipment.terminal.class')

local equipment_list = {generator, transmitter, terminal}

for ID, equipment in ipairs(equipment_list) do 
--print(equipment:getName(), ID)
  equipment_list[equipment:getName()] = ID 
  equipment.ID = ID
end

local function lookup(equipment)
--print(equipment)  
  if type(equipment) == 'string' then 
    local ID = equipment_list[equipment]
    equipment = equipment_list[ID]
  elseif type(equipment) == 'number' then
    local ID = equipment
    equipment = equipment_list[ID]
  else
    error('equipment lookup invalid')
  end
  return equipment
end

return lookup