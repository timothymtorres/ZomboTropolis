local Generator =   require('code.location.building.equipment.generator')
local Transmitter = require('code.location.building.equipment.transmitter')
local Terminal =    require('code.location.building.equipment.terminal')

local Machines = {Generator, Transmitter, Terminal,}

for _, Class in ipairs(Machines) do
  local class_name = string.lower(Class.name)
  Machines[class_name] = Class
end

return Machines