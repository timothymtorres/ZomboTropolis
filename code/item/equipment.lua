local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

local Generator = class('Generator', ItemBase)

Generator.FULL_NAME = 'generator'
Generator.WEIGHT = 25
Generator.DURABILITY = 0
Generator.CATEGORY = 'engineering'
Generator.ap = {cost = 10, modifier = {tech = -2, power_tech = -4}}

function Generator:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to install generator')
  assert(not p_tile.generator:isPresent(), 'There is no room for a second generator') 
end

Generator.server_criteria = Generator.client_criteria

function Generator:activate(player)
  local building_tile = player:getTile()
  building_tile:insert('generator', self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a generator.'
  local msg =      '{player} installs a generator.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'generator', player}   
  player:broadcastEvent(msg, self_msg, event)     
end

-------------------------------------------------------------------

local Transmitter = class('Transmitter', ItemBase)

Transmitter.FULL_NAME = 'transmitter'
Transmitter.WEIGHT = 25
Transmitter.DURABILITY = 0
Transmitter.CATEGORY = 'engineering'
Transmitter.ap = {cost = 10, modifier = {tech = -2, radio_tech = -4}}

function Transmitter:client_criteria(player)
  local p_tile = player:getTile()  
  assert(player:isStaged('inside'), 'Must be inside building to install transmitter')
  assert(not p_tile.transmitter:isPresent(), 'There is no room for a second transmitter')
end

Transmitter.server_criteria = Transmitter.client_criteria

function Transmitter:activate(player)
  local building_tile = player:getTile()
  building_tile:insert('transmitter', self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a transmitter.'
  local msg =      '{player} installs a transmitter.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'transmitter', player}    
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

local Terminal = class('Terminal', ItemBase)

Terminal.FULL_NAME = 'terminal'
Terminal.WEIGHT = 25
Terminal.DURABILITY = 0
Terminal.CATEGORY = 'engineering'
Terminal.ap = {cost = 10, modifier = {tech = -2, computer_tech = -4}} 

function Terminal:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to install terminal')
  assert(not p_tile.terminal:isPresent(), 'There is no room for a second terminal')
end

Terminal.server_criteria = Terminal.client_criteria

function Terminal:activate(player)
  local building_tile = player:getTile()
  building_tile:insert('terminal', self.condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a terminal.'
  local msg =      '{player} installs a terminal.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'terminal', player}  
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

local Fuel = class('Fuel', ItemBase)

Fuel.FULL_NAME = 'fuel tank'
Fuel.WEIGHT = 10
Fuel.DURABILITY = 0
Fuel.CATEGORY = 'engineering'
Fuel.ap = {cost = 1}

function Fuel:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to refuel')
  assert(p_tile.generator:isPresent(), 'Missing nearby generator to refuel')
end

Fuel.server_criteria = Fuel.client_criteria

function Fuel:activate(player)
  local building_tile = player:getTile()
  building_tile.generator:refuel()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You refuel the generator.'
  local msg =      '{player} refuels the generator.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'fuel', player}    
  player:broadcastEvent(msg, self_msg, event)     
end

-------------------------------------------------------------------

local Barricade = class('Barricade', ItemBase)

Barricade.FULL_NAME = 'barricade'
Barricade.WEIGHT = 7
Barricade.DURABILITY = 0
Barricade.CATEGORY = 'engineering'
Barricade.ap = {cost = 1}

function Barricade:client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to barricade')
  assert(p_tile.barricade:roomForFortification(), 'There is no room available for fortifications')
  assert(p_tile.barricade:canPlayerFortify(player), 'Unable to make stronger fortification without required skills')  
  assert(not p_tile.integrity:isState('ruined'), 'Unable to make fortifications in a ruined building')
end

Barricade.server_criteria = Barricade.client_criteria

function Barricade:activate(player)
  local building_tile = player:getTile()
  local did_zombies_interfere = building_tile.barricade:didZombiesIntervene(player)
  
  if not did_zombies_interfere then building_tile.barricade:fortify(player, self.condition) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = not did_zombies_interfere and 'You fortify the building with a barricade.' or 'You start to fortify the building, but a zombie lurches towards you.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'barricade', player, did_zombies_interfere}    
  player.log:insert(msg, event)   

  return did_zombies_interefere -- not sure if there is a better way to deal with returning the result (needed for the item:updateDurability() code) [only used by syringes and barricades]
end

-------------------------------------------------------------------

local Toolbox = class('Toolbox', ItemBase)

Toolbox.FULL_NAME = 'toolbox'
Toolbox.WEIGHT = 15
Toolbox.DURABILITY = 10
Toolbox.CATEGORY = 'engineering'
Toolbox.ap = {cost = 10, modifier = {repair = -2, repair_adv = -3}} --{cost= 5, modifier={repair= -1, repair_adv = -1}}

function Toolbox:client_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside building to repair')
  local p_tile = player:getTile()
  local can_repair_building = p_tile.integrity:canModify(player)
  assert(can_repair_building, 'Unable to repair building in current state')
end

Toolbox.server_criteria = Toolbox.client_criteria

local toolbox_dice = {'3d2-2', '3d2-1', '3d2', '3d2+1'}

function Toolbox:activate(player)
  local repair_dice = dice:new(toolbox_dice[self.condition])
  if player.skills:check('repair') then repair_dice = repair_dice / 1 end
  if player.skills:check('repair_adv') then repair_dice = repair_dice ^ 3 end
  
  local building = player:getTile()
  building.integrity:updateHP(repair_dice:roll() )
  local integrity_state = building.integrity:getState()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You repair the building {is_finished}.'
  local msg =      '{player} repairs the building {is_finished}.'
  local names = {player=player, is_finished=integrity_state == 'intact' and 'completely' or ''}
  self_msg = self_msg:replace(names)
  msg =           msg:replace(names)   
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'toolbox', integrity_state}    
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

return {Generator, Transmitter, Terminal, Fuel, Barricade, Toolbox}