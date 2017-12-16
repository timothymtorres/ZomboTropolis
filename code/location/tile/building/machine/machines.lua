local Generator = require('code.location.tile.building.machine.generator')
local Transmitter = require('code.location.tile.building.machine.transmitter')
local Terminal = require('code.location.tile.building.machine.terminal')

local Machines = {Generator, Transmitter, Terminal,}

for _, Class in ipairs(Machines) do
  Machines[Class.name] = Class
end

return Machines