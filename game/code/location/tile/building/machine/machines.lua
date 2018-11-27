local Generator = require('code.location.tile.building.machine.generator')
local Transmitter = require('code.location.tile.building.machine.transmitter')
local Terminal = require('code.location.tile.building.machine.terminal')

local Machines = {Generator, Transmitter, Terminal,}

for _, Class in ipairs(Machines) do
  local machine = string.lower(tostring(Class.name))	
  Machines[machine] = Class
end

return Machines