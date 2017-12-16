local class = require('code.libs.middleclass')
local Machine = require('code.location.tile.building.machine.machine')

local Generator = class('Generator', Machine)
local MAX_FUEL = 15

Generator.FULL_NAME = 'generator'
Generator.DURABILITY = 100
Generator.CATEGORY = 'engineering'

function Generator:initialize(building) 
  Machine.initialize(self, building)
  self.fuel = 0 
end

function Generator:refuel() self.fuel = MAX_FUEL end

function Generator:isActive() return self.fuel > 0 end 

function Generator:hasOperations() return false end

return Generator