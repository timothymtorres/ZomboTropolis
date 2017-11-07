local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

local Generator = class('Generator', ItemBase)

Generator.static = {
  FULL_NAME = 'generator',
  WEIGHT = 25,
  DURABILITY = 0,
  CATEGORY = 'engineering'
}

function Generator.client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to install generator')
  assert(not p_tile.generator:isPresent(), 'There is no room for a second generator') 
end

Generator.server_criteria = Generator.client_criteria

function Generator.activate(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('generator', condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a generator.'
  local msg =      '{player} installs a generator.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'generator', player}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)     
end

-------------------------------------------------------------------

local Transmitter = class('Transmitter', ItemBase)

Transmitter.static = {
  FULL_NAME = 'transmitter',
  WEIGHT = 25,
  DURABILITY = 0,
  CATEGORY = 'engineering'  
}

function Transmitter.client_criteria(player)
  local p_tile = player:getTile()  
  assert(player:isStaged('inside'), 'Must be inside building to install transmitter')
  assert(not p_tile.transmitter:isPresent(), 'There is no room for a second transmitter')
end

Transmitter.server_criteria = Transmitter.client_criteria

function Transmitter.activate(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('transmitter', condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a transmitter.'
  local msg =      '{player} installs a transmitter.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'transmitter', player}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

local Terminal = class('Terminal', ItemBase)

Terminal.static = {
  FULL_NAME = 'terminal',
  WEIGHT = 25,
  DURABILITY = 0,
  CATEGORY = 'engineering'  
}

function Terminal.client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to install terminal')
  assert(not p_tile.terminal:isPresent(), 'There is no room for a second terminal')
end

Terminal.server_criteria = Terminal.client_criteria

function Terminal.activate(player, condition)
  local building_tile = player:getTile()
  building_tile:insert('terminal', condition)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You install a terminal.'
  local msg =      '{player} installs a terminal.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'terminal', player}
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

local Fuel = class('Fuel', ItemBase)

Fuel.static = {
  FULL_NAME = 'fuel tank',
  WEIGHT = 10,
  DURABILITY = 0,
  CATEGORY = 'engineering'  
}

function Fuel.client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to refuel')
  assert(p_tile.generator:isPresent(), 'Missing nearby generator to refuel')
end

Fuel.server_criteria = Fuel.client_criteria

function Fuel.activate(player, condition)
  local building_tile = player:getTile()
  building_tile.generator:refuel()
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg = 'You refuel the generator.'
  local msg =      '{player} refuels the generator.'  
  msg = msg:replace(player)
  
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'fuel', player}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)     
end

-------------------------------------------------------------------

local Barricade = class('Barricade', ItemBase)

Barricade.static = {
  FULL_NAME = 'barricade',
  WEIGHT = 7,
  DURABILITY = 0,
  CATEGORY = 'engineering'  
}

function Barricade.client_criteria(player)
  local p_tile = player:getTile()
  assert(player:isStaged('inside'), 'Must be inside building to barricade')
  assert(p_tile.barricade:roomForFortification(), 'There is no room available for fortifications')
  assert(p_tile.barricade:canPlayerFortify(player), 'Unable to make stronger fortification without required skills')  
  assert(not p_tile.integrity:isState('ruined'), 'Unable to make fortifications in a ruined building')
end

Barricade.server_criteria = Barricade.client_criteria

function Barricade.activate(player, condition)
  local building_tile = player:getTile()
  local did_zombies_interfere = building_tile.barricade:didZombiesIntervene(player)
  
  if not did_zombies_interfere then building_tile.barricade:fortify(player, condition) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = not did_zombies_interfere and 'You fortify the building with a barricade.' or 'You start to fortify the building, but a zombie lurches towards you.'
    
  --------------------------------------------
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'barricade', player, did_zombies_interfere}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player.log:insert(msg, event)   
end

-------------------------------------------------------------------

local Toolbox = class('Toolbox', ItemBase)

Toolbox.static = {
  FULL_NAME = 'toolbox',
  WEIGHT = 15,
  DURABILITY = 10,
  CATEGORY = 'engineering'  
  MASTER_SKILL = 'repair_adv',  
}

function Toolbox.client_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside building to repair')
  local p_tile = player:getTile()
  local can_repair_building = p_tile.integrity:canModify(player)
  assert(can_repair_building, 'Unable to repair building in current state')
end

Toolbox.server_criteria = Toolbox.client_criteria

local toolbox_dice = {'3d2-2', '3d2-1', '3d2', '3d2+1'}

function Toolbox.activate(player, condition)
  local repair_dice = dice:new(toolbox_dice[condition])
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
  -------------   E V E N T   ----------------
  --------------------------------------------
  
  local event = {'toolbox', integrity_state}  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

return {Generator, Transmitter, Terminal, Fuel, Barricade, Toolbox}