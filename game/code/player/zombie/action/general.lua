local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')

local general_actions = {}
-------------------------------------------------------------------

local groan = {}
general_actions.groan = groan

function groan.client_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to groan')
end

function groan.server_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to groan')
end

local GROAN_MAX_RANGE = 6
local GROAN_DENOMINATOR = 3
local groan_description = {'disappointed', 'bored', 'pleased', 'satisfied', 'excited', 'very excited'}

function groan.activate(player)
  local x, y, z = player:getPos()
  local tile = player:getTile()
  local human_n = tile:countPlayers('human', player:getStage())
  local groan_range = math.floor(human_n/GROAN_DENOMINATOR + 0.5)
  local range = math.min(groan_range, GROAN_MAX_RANGE)

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  -- Groan point of orgin
  local self_msg = 'You emit a {interest} groan.'
  local human_msg = 'A zombie groans {pos}.'
  local zombie_msg = 'You hear a {interest} groan {pos}.'

  local words = {interest=groan_description[range], pos='{'..y..', '..x..'}'}
  self_msg =     self_msg:replace(words)
  zombie_msg = zombie_msg:replace(words)
  human_msg =   human_msg:replace(words)

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'groan', player} -- (y, x, range) include this later?  We can use sound effects when this event is triggered based on distances
  --local event_human_inside, event_human_outside = {'groan', player}, {'groan', player, y, x}
  --humans with military class can pinpoint the groan exactly?

  local exclude = {}
  exclude[player] = true
  exclude[tile] = true

  local settings = {
    --for_humans_inside =  {stage='inside',  mob_type='human'},
    --for_humans_outside = {stage='outside', mob_type='human',  range=range},
    humans =  {mob_type='human',  range=range, exclude = exclude},
    zombies = {mob_type='zombie', range=range, exclude = exclude},
  }

  player.log:insert(self_msg, event)
  tile:broadcastEvent(zombie_msg, event, settings.zombies)
  tile:broadcastEvent(human_msg, event, settings.humans)

  --[[  OLD CODE from description.groan()
  local player_y, player_x = player:getPos()
  local y_dist, x_dist = player_y - y, player_x - x
  if y_dist == 0 and x_dist == 0 then msg[3] = msg[3]..' at your current location.' end

  if y_dist > 0 then msg[3] = msg[3]..math.abs(y_dist)..' South'
  elseif y_dist < 0 then msg[3] = msg[3]..math.abs(y_dist)..' North'
  end

  if x_dist > 0 then msg[3] = msg[3]..math.abs(x_dist)..' East'
  elseif x_dist < 0 then msg[3] = msg[3]..math.abs(x_dist)..' West'
  end
  --]]
end

-------------------------------------------------------------------

local gesture = {}
general_actions.gesture = gesture

function gesture.client_criteria(player)
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage())
  assert(player_n - 1  > 0, 'Must have players nearby to gesture')
end

function gesture.server_criteria(player)
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage())
  assert(player_n - 1 > 0, 'Must have players nearby to gesture')
end

local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

function gesture.activate(player, target)
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  local object

  if type(target) == 'number' then object = compass[target]
  elseif target:getClassName() == 'player' then object = target
  else object = 'the '..target -- must be building
  end

  local self_msg = 'You gesture towards {object}.'
  local msg = 'A zombie gestures towards {object}.'
  self_msg = self_msg:replace(object)
  msg =           msg:replace(object)

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'gesture', player, target}
  player:broadcastEvent(msg, self_msg, event)
end

-------------------------------------------------------------------

local hivemind = {}
general_actions.hivemind = himemind

function hivemind.server_criteria(player, setting)
  assert(setting, 'Must have selected a setting')
  if type(setting) == 'number' then
    assert(setting > 0 and setting <= 1024, 'Hivemind channel is out of range')
    assert(not player.network:check(setting), 'Your hivemind is already set to this channel')
  elseif type(setting) == 'message' then
    -- check size of string
  else
    assert(false, 'Hivemind setting type is incorrect')
  end
end

function hivemind.activate(player, setting)
  if type(setting) == 'number' then player.network:update(setting)
  elseif type(setting) == 'string' then player.network:transmit(setting)
  end

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  local msg

  if type(setting) == 'number' then
    msg = 'You tune in to the {channel} hivemind channel.'
    --msg = msg:replace(player.network:getChannelName(setting))     (don't worry about channel name string yet)
  else -- it's a message
    msg = '('..channel..'): '..message
  end

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'hivemind', player, setting}
  player.log:insert(msg, event)
end

-------------------------------------------------------------------

return general_actions
