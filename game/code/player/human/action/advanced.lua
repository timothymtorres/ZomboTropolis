local broadcastEvent = require('code.server.event')
string.replace = require('code.libs.replace')

-------------------------------------------------------------------

local search = {name='search', ap={cost=1}}

function search.activate(player)
  local p_tile = player:getTile()
  local flashlight_was_used, flashlight_condition
  
  local flashlight = player.inventory:searchForItem('Flashlight')
  local player_inside_unpowered_building = not p_tile:isPowered() and player:isStaged('inside')
  
  local discovery = p_tile:search(player, player:getStage(), flashlight)

  local flashlight_state

  if flashlight and player_inside_unpowered_building then -- flashlight is only used when building has no power
    flashlight_state = "FLASHLIGHT_PRESENT"
    flashlight_was_used = true
    flashlight_condition = player.inventory:updateDurability(flashlight) 
  end

  local item, hidden_player

  if discovery and discovery:isInstanceOf('Item') then item = discovery
  elseif discovery and discovery:isInstanceOf('Player') then hidden_player = discovery
  end

  if item then player.inventory:insert(item) end
  if hidden_player then hidden_player.status_effect:remove('hide') end

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
   
  local self_msg = 'You search {with_flashlight} and find {discovery}.'
  local names = {
    with_flashlight = flashlight_was_used and 'with a flashlight' or '',
    discovery = discovery and 'a '..tostring(discovery) or 'nothing',
    player = player,
    hidden_player = hidden_player, 
  }
  self_msg = self_msg:replace(names)
  
  local public_msg, hidden_player_msg

  if hidden_player then
    public_msg = '{player} searches and finds {hidden_player}.'
    hidden_player_msg = 'You are discovered by {player}!'
    public_msg = public_msg:replace(names)
    hidden_player_msg = hidden_player_msg:replace(names)
  end

  if flashlight_condition == 0 then 
    self_msg = self_msg..'Your '..tostring(flashlight)..' is destroyed!'
    flashlight_state = "FLASHLIGHT_DESTROYED"
  elseif flashlight_condition and flashlight:isConditionVisible(player) then 
    self_msg = self_msg..'Your '..tostring(flashlight)..' degrades to a '..flashlight:getConditionState()..' state.'
    flashlight_state = "FLASHLIGHT_DEGRADED"
  end  

  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------     

  flashlight_state = flashlight_state or "FLASHLIGHT_NOT_PRESENT"
  local event = {'search', player, discovery, flashlight_state}  

  if hidden_player then
    local settings = {stage=player:getStage(), exclude={}}
    settings.exclude[player], settings.exclude[hidden_player] = true, true  
    
    player.log:insert(self_msg, event)
    hidden_player.log:insert(hidden_player_msg, event)
    
    local tile = player:getTile()
    tile:broadcastEvent(public_msg, event, settings)    
  else 
    player.log:insert(self_msg, event)
  end

  return event 
end

-------------------------------------------------------------------

local discard = {name='discard', ap={cost=0}}

function discard.activate(player, inv_pos)
  local item = player.inventory:getItem(inv_pos)
  player.inventory:remove(item)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
    
  local msg = 'You discard a {item}.'
  msg = msg:replace(item)    
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------   
  
  local event = {'discard', player, item}    
  player.log:insert(msg, event)
end

-------------------------------------------------------------------

local speak = {name='speak', ap={cost=0}}

function speak.client_criteria(player) 
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1
  assert(player_n > 0, 'No available players to speak to')
end

function speak.server_criteria(player, message) --, target) 
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1
  assert(player_n > 0, 'No players nearby to communicate')       
  assert(message, 'Must have a message to speak')
  assert(type(message) == 'string', 'Message must be a string')
  assert(string.len(message) < 255, 'Message length too long')
     
--[[  This is a later feature used for whispering to a single person     
  assert(target, 'Must have a target to speak')      
  assert(target:isStanding(), 'Target has been killed')
  assert(player:isSameLocation(target), 'Target has moved out of range')  
--]]  
end


function speak.activate(player, message, target)  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local whispered_msg, self_msg, public_msg
  
  if target then -- whisper to target only
    whispered_msg = '{player} whispered: "{msg}"'
    self_msg =      'You whispered to {target}: "{msg}"'
    public_msg =    '{player} whispers to {target}.'
  else           -- say outloud to everyone
    self_msg =      'You said: "{msg}"'
    public_msg =    '{player} said: "{msg}"'
  end
  
  local names = {player=player, target=target, msg=message}
  whispered_msg = whispered_msg and whispered_msg:replace(names)
  self_msg =                             self_msg:replace(names)
  public_msg =                         public_msg:replace(names)  
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'speak', player, message, target}    
  
  local settings = {stage=player:getStage(), exclude={}}
  settings.exclude[player], settings.exclude[target] = true, true  
  
  if target then
    player.log:insert(self_msg, event)
    target.log:insert(whispered_msg, event)
    event[3] = nil -- other players should not hear message
    
    local tile = player:getTile()
    tile:broadcastEvent(public_msg, event, settings)    
  else
    player:broadcastEvent(public_msg, self_msg, event)     
  end
end

-------------------------------------------------------------------

local reinforce = {name='reinforce', ap={cost=1}}

function reinforce.client_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to reinforce')
  assert(player:isStaged('inside'), 'Player must be inside building to reinforce')
  assert(not p_tile.integrity:isState('ruined'), 'Unable to reinforce a ruined building')
  assert(p_tile.barricade:canReinforce(), 'No room for reinforcements in building')
  assert(player.skills:check('reinforce'), 'Must have skill to reinforce building')
end

function reinforce.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to reinforce')
  assert(player:isStaged('inside'), 'Player must be inside building to reinforce')
  assert(not p_tile.integrity:isState('ruined'), 'Unable to reinforce a ruined building')
  assert(p_tile.barricade:canReinforce(), 'No room for reinforcements in building')
  assert(player.skills:check('reinforce'), 'Must have skill to reinforce building')  
end

function reinforce.activate(player)
  local p_tile = player:getTile()
  local building_was_reinforced, potential_hp = p_tile.barricade:reinforceAttempt()
  local did_zombies_interfere = p_tile.barricade:didZombiesIntervene(player)
  
  if building_was_reinforced and not did_zombies_interfere then p_tile.barricade:reinforce(potential_hp) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
    
  local self_msg, msg
  
  if building_was_reinforced and not did_zombies_interfere then 
    self_msg, msg = 'You reinforce the building making room for fortifications.', '{player} reinforces the building making room for fortifications.'
  elseif did_zombies_interfere then
    self_msg, msg = 'You start to reinforce the building but a zombie lurches towards you.', '{player} starts to reinforce the building but is interrupted by a zombie.'    
  elseif not building_was_reinforced then
    self_msg, msg = 'You attempt to reinforce the building but fail.', '{player} attempts to reinforce the building but fails.'
  end    
  
  msg = msg:replace(player)
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------   
  
  local event = {'reinforce', player, did_zombies_interfere, building_was_reinforced, potential_hp} -- should we do something with potential hp?      
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

local item = {name='item'}

function item.server_criteria(player, inv_pos, ...)
  assert(inv_pos, 'Missing inventory position for item')
  assert(player.inventory:isPresent(inv_pos), 'Item not in inventory')  
  
  local itemObj = player.inventory:getItem(inv_pos)
  if itemObj.server_criteria then itemObj.server_criteria(player, ...) end
end

function item.activate(player, inv_pos, target)
  local itemObj = player.inventory:getItem(inv_pos)
  local is_durability_skipped = itemObj:activate(player, target)

  if not is_durability_skipped then 
    local condition = player.inventory:updateDurability(itemObj) 

    if condition == 0 then 
      player.log:append('Your '..tostring(itemObj)..' is destroyed!')
    elseif condition and itemObj:isConditionVisible(player) then 
      player.log:append('Your '..tostring(itemObj)..' degrades to a '..itemObj:getConditionState()..' state.')
    end
  end
end

-------------------------------------------------------------------

local equipment = {name='equipment'}

function equipment.client_criteria(player) --, machine, operation)
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  assert(p_tile:isPresent('transmitter') or p_tile:isPresent('terminal'), 'There is no building equipment to use')
end

function equipment.server_criteria(player, machine, operation)
  --assert(operation, 'Missing equipment operation for action')  The terminal requires no operation arg?
  
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player to use equipment')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
end

function equipment.activate(player, machine, operation, ...)  
  -- condition degrade code goes here
  local building = player:getTile()
  local machine = building:getMachine(machine)
  machine:activate(operation, ...)
end

return {search, discard, speak, reinforce, item, equipment}