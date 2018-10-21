local class = require('code.libs.middleclass')
local Machine = require('code.location.tile.building.machine.machine')

local Generator = class('Generator', Machine)
local MAX_FUEL = 15

Generator.FULL_NAME = 'generator'
Generator.DURABILITY = 100
Generator.CATEGORY = 'engineering'

function Generator:initialize(building) 
  self.fuel = 0 
  Machine.initialize(self, building)
end

function Generator:refuel() self.fuel = MAX_FUEL end

function Generator:isActive() return self.fuel > 0 end 

function Generator:hasOperations() return false end

function Generator:activate()
  local hidden_players = self:getPlayers(setting, 'hide')
  if hidden_players then for player in pairs(hidden_players) do player.status_effect:remove('hide') end end

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
   
  local msg = 'The power to the {building} turns on.'
  msg = msg:replace(self.building)

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------     

  local event = {'generator', hidden_players} -- maybe change event[1] to 'lightup', 'illumiinate', etc.?
  tile:broadcastEvent(msg, event, settings)  
end

return Generator