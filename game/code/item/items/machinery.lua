local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')
local dice = require('code.libs.dice')

local Generator = class('Generator', Item)

Generator.FULL_NAME = 'generator'
Generator.WEIGHT = 25
Generator.DURABILITY = 0
Generator.CATEGORY = 'engineering'
Generator.ap = {cost = 10, modifier = {tech = -3, tech_adv = -4}}

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

local Transmitter = class('Transmitter', Item)

Transmitter.FULL_NAME = 'transmitter'
Transmitter.WEIGHT = 25
Transmitter.DURABILITY = 0
Transmitter.CATEGORY = 'engineering'
Transmitter.ap = {cost = 10, modifier = {tech = -3, tech_adv = -4}}

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

local Terminal = class('Terminal', Item)

Terminal.FULL_NAME = 'terminal'
Terminal.WEIGHT = 25
Terminal.DURABILITY = 0
Terminal.CATEGORY = 'engineering'
Terminal.ap = {cost = 10, modifier = {tech = -3, tech_adv = -4}} 

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

return {Generator, Transmitter, Terminal}