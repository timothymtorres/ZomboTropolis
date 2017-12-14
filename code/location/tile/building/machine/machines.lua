local Generator = require('code.location.building.machine.generator')
local Transmitter = require('code.location.building.machine.transmitter')
local Terminal = require('code.location.building.machine.terminal')

local Machines = {Generator, Transmitter, Terminal,}

for _, Class in ipairs(Machines) do
  local class_name = string.lower(Class.name)
  Machines[class_name] = Class
end

return Machines