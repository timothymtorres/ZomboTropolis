local class = require('code.libs.middleclass')
local equipment = require('code.location.building.equipment.class')

local generator = class('generator', equipment)
local max_fuel = 15

function generator:initialize() 
  equipment.initialize(self)
  self.fuel = 0 
end

function generator:refuel() self.fuel = max_fuel end

function generator:isActive() return (self:isPresent() and self.fuel > 0) or false end 

function generator:hasOperations() return false end

return generator