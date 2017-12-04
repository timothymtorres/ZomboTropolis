local class = require('code.libs.middleclass')
local EquipmentBase = require('code.location.building.equipment.equipment_base')

local Terminal = class('Terminal', EquipmentBase)
local MAX_HP = 7
local operations = {}

Terminal.FULL_NAME = 'terminal'
Terminal.DURABILITY = 100
Terminal.CATEGORY = 'engineering'
Terminal.ap = {cost = 3, modifier = {tech = -1, computer_tech = -1}} -- this might not be the correct way to do this (need seperate ap costs for actions? retune, transmit, etc.?)

function Terminal:initialize() 
  equipment.initialize(self)
end

function Terminal:install() 
  self.hp = MAX_HP
end

function Terminal:getOperations() return operations end

function Terminal:hasOperations() return false end

return Terminal