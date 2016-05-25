local class = require('code.libs.middleclass')
local equipment = require('code.location.building.equipment.class')

local terminal = class('terminal', equipment)
local max_hp = 7
local operations = {}

function terminal:initialize() 
  equipment.initialize(self)
end

function terminal:install() 
  self.hp = max_hp 
end

function terminal:getOperations() return operations end

function terminal:hasOperations() return false end

return terminal