local equipment = {}

--[[
  full_name = 'insert name'
  weight = num
  class_category = 'engineering'
  durability = 0/1/+num    [0 = one use, 1 = one usage each time, +num = 1/num chance of usage]
--]]

equipment.generator = {}
equipment.generator.full_name = 'generator'
equipment.generator.weight = 25
equipment.generator.durability = 0

equipment.transmitter = {}
equipment.transmitter.full_name = 'transmitter'
equipment.transmitter.weight = 25
equipment.transmitter.durability = 0

equipment.terminal = {}
equipment.terminal.full_name = 'terminal'
equipment.terminal.weight = 25
equipment.terminal.durability = 0

equipment.fuel = {}
equipment.fuel.full_name = 'fuel tank'
equipment.fuel.weight = 10
equipment.fuel.durability = 0

equipment.barricade = {}
equipment.barricade.full_name = 'barricade'
equipment.barricade.weight = 7
equipment.barricade.durability = 0

equipment.toolbox = {}
equipment.toolbox.full_name = 'toolbox'
equipment.toolbox.weight = 15
equipment.toolbox.master_skill = 'repair_adv'
equipment.toolbox.durability = 10

for item in pairs(equipment) do 
  equipment[item].class_category = 'engineering' 
end

return equipment