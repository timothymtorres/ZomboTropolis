local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

local human_machine_actions = {}

-------------------------------------------------------------------

local function machine_criteria(player, machine)
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  assert(p_tile:isPresent(machine), 'That machine is not present in building')
end

-------------------------------------------------------------------

human_machine_actions.survey = {}
local survey = human_machine_actions.survey

function survey.client_criteria(player) machine_criteria(player, 'terminal') end

function survey.server_criteria(player) machine_criteria(player, 'terminal') end

function survey.activate(player)
  local p_tile = player:getTile()
  local terminal = p_tile:getMachine('terminal') 
  terminal:survey(player) 
  terminal:updateDurability()
end

------------------------------------------------------

human_machine_actions.broadcast = {}
local broadcast = human_machine_actions.broadcast

function broadcast.client_criteria(player) machine_criteria(player, 'transmitter') end

function broadcast.server_criteria(player) machine_criteria(player, 'transmitter') end

function broadcast.activate(player, message)
  local p_tile = player:getTile()
  local transmitter = p_tile:getMachine('transmitter') 
  transmitter:broadcast(player, message)
  transmitter:updateDurability()
end

------------------------------------------------------

human_machine_actions.retune = {}
local retune = human_machine_actions.retune

function retune.client_criteria(player) machine_criteria(player, 'transmitter') end

function retune.server_criteria(player) machine_criteria(player, 'transmitter') end

function retune.activate(player, new_freq)  
  local p_tile = player:getTile()
  local transmitter = p_tile:getMachine('transmitter') 
  transmitter:retune(player, new_freq)
  transmitter:updateDurability()
end

return human_machine_actions