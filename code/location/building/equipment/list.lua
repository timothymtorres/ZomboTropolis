local equipment = {}

--[[
  full_name = 'insert name'
  class_category = 'engineering'
  durability = num (average # of uses when equipment installed before it wears out)
--]]

equipment.generator = {}
equipment.generator.full_name = 'generator'
equipment.generator.durability = 100

equipment.transmitter = {}
equipment.transmitter.full_name = 'transmitter'
equipment.transmitter.durability = 100

equipment.terminal = {}
equipment.terminal.full_name = 'terminal'
equipment.terminal.durability = 100

for item in pairs(equipment) do 
  equipment[item].class_category = 'engineering' 
end

function Equipment.client_criteria(name, player) -- operation)
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  
  -- add p_tile to vars?
  if equipmentCheck[name] then equipmentCheck[name](player) end -- we need to be using equipment.client_criteria here somehow 
end

function Equipment.server_criteria(name, player, operation)
  assert(operation, 'Missing equipment operation for action')
  
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player to use equipment')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  
  -- add p_tile to vars?
  if equipmentCriteria[name] then equipmentCriteria[name](player, operation) end  
end

function Equipment.activate(name, player, operation, ...)  -- condition degrade on use?
  return equipmentActivate[name](player, operation, ...) --unpack({...}))
end


return equipment