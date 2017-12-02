local class = require('code.libs.middleclass')
local EquipmentBase = require('code.location.building.equipment.equipment_base')

local Generator = class('Generator', EquipmentBase)
local MAX_FUEL = 15

function Generator:initialize() 
  EquipmentBase.initialize(self)
  self.fuel = 0 
end

function Generator:refuel() self.fuel = MAX_FUEL end

function Generator:isActive() return (self:isPresent() and self.fuel > 0) or false end 

function Generator:hasOperations() return false end

return Generator