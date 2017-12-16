local Generator = require('code.location.building.machine.generator')
local Transmitter = require('code.location.building.machine.transmitter')
local Terminal = require('code.location.building.machine.terminal')

local Machines = {Generator, Transmitter, Terminal,}

for _, Class in ipairs(Machines) do
  Machines[Class.name] = Class
end

return Machines