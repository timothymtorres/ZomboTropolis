local class = require('code.libs.middleclass')
local equipment = require('code.location.building.equipment.class')

local transmitter = class('transmitter', equipment)
local max_hp = 7
local operations = {'broadcast', 'retune'}

function transmitter:initialize() 
  equipment.initialize(self)
  self.freq = 0
end

function transmitter:install() 
  self.hp = max_hp 
  self.freq = math.random(1, 1024)
end

function transmitter:broadcast(player, message, condition) channel:transmit(self.freq, player, message, condition) end

function transmitter:retune(player, new_freq)  
  local receiver = self:getBuilding()
  channel:remove(self.freq, receiver)
  channel:insert(new_freq, receiver)
  self.freq = freq  
end

function transmitter:getOperations() return operations end 

function transmitter:hasOperations() return true end

return transmitter