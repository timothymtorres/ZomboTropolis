local Generator =   require('code.location.building.equipment.generator')
local Transmitter = require('code.location.building.equipment.transmitter')
local Terminal =    require('code.location.building.equipment.terminal')

local Equipment = {
  Generator, Transmitter, Terminal,
}

for _, Class in ipairs(Equipment) do
  Equipment[Class.name] = Class
end

return Equipment