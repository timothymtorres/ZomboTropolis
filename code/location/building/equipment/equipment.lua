local Generator =   require('code.location.building.equipment.generator')
local Transmitter = require('code.location.building.equipment.transmitter')
local Terminal =    require('code.location.building.equipment.terminal')

local Equipment = {
  Generator, Transmitter, Terminal,
}

for _, Class in ipairs(Equipment) do
  Equipment[Class.name] = Class
end

function Equipment.client_criteria(name, player) -- operation)
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
end

function Equipment.server_criteria(name, player, operation)
  assert(operation, 'Missing equipment operation for action')
  
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player to use equipment')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
end

function Equipment.activate(name, player, operation, ...)  
  -- condition degrade code goes here
end

return Equipment