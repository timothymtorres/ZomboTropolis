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

return equipment