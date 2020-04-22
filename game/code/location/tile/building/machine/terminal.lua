local class = require('code.libs.middleclass')
local Machine = require('code.location.tile.building.machine.machine')

local Terminal = class('Terminal', Machine)
local MAX_HP = 7
local operations = {}

Terminal.FULL_NAME = 'terminal'
Terminal.DURABILITY = 100
Terminal.CATEGORY = 'engineering'
Terminal.ap = {cost = 3, modifier = {gadget = -1, terminal = -1}}

function Terminal:initialize(building) 
  self.hp = MAX_HP
  Machine.initialize(self, building)
end

------------------------------------------------------

function Terminal:survey(player)
	local map = player:getMap()
  local zombies_num, zombies_levels, zombies_pos = map.terminal_network:access(self, player)

print('-----------')
print('Terminal network has been accessed')
print('Total zombies is: ', zombies_num)
print('Total zombie experience levels are: ', zombies_levels)
print('Zombie positions are the following: ', zombies_pos)

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You access the terminal.'
  local msg =      '{player} accesses the terminal.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'terminal', player, zombies_num, zombies_levels, zombies_pos}  
  player:broadcastEvent(msg, self_msg, event)   
	-- need to do something with data on player UI
end

return Terminal