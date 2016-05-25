local equipment = {}

--[[
  full_name = 'insert name'
  size = 1/2/3/4
  weight = num
  class_category = 'engineering'
  condition_omitted = nil/true  (if omitted, item has no condition levels)  
  special = nil/4/16  (bit_flags for special)  [radio_freq, ammo, color, battery_life, etc.] 
--]]

equipment.generator = {}
equipment.generator.full_name = 'generator'
equipment.generator.weight = 25

equipment.transmitter = {}
equipment.transmitter.full_name = 'transmitter'
equipment.transmitter.weight = 25

equipment.terminal = {}
equipment.terminal.full_name = 'terminal'
equipment.terminal.weight = 25

equipment.fuel = {}
equipment.fuel.full_name = 'fuel tank'
equipment.fuel.weight = 10

for item in pairs(equipment) do equipment[item].class_category = 'equipment' end

return equipment