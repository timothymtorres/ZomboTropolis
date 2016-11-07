local equipment = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'engineering'
  one_use = true
  durability = num (average # of uses when equipment installed before it wears out)
--]]

equipment.generator = {}
equipment.generator.full_name = 'generator'
equipment.generator.weight = 25
equipment.generator.durability = 100

equipment.transmitter = {}
equipment.transmitter.full_name = 'transmitter'
equipment.transmitter.weight = 25
equipment.transmitter.durability = 100

equipment.terminal = {}
equipment.terminal.full_name = 'terminal'
equipment.terminal.weight = 25
equipment.terminal.durability = 100

equipment.fuel = {}
equipment.fuel.full_name = 'fuel tank'
equipment.fuel.weight = 10

equipment.barricade = {}
equipment.barricade.full_name = 'barricade'
equipment.barricade.weight = 7

for item in pairs(equipment) do 
  equipment[item].class_category = 'engineering' 
  equipment[item].one_use = true
end

return equipment