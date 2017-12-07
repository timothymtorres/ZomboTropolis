local dice =              require('code.libs.dice')
local Item =              require('code.item.item')
local broadcastEvent =    require('code.server.event')
string.replace =          require('code.libs.replace')

-------------------------------------------------------------------

local search = {name='search', ap={cost=1}}

function search.activate(player)
  local p_tile = player:getTile()
  local flashlight_was_used
  
  local player_has_flashlight, inv_ID = player.inventory:search('flashlight')
  local player_inside_unpowered_building = not p_tile:isPowered() and player:isStaged('inside')
  
  local item = p_tile:search(player, player:getStage(), player_has_flashlight)
  
  if player_has_flashlight and player_inside_unpowered_building then -- flashlight is only used when building has no power
    flashlight_was_used = true
    local flashlight = player.inventory:lookup(inv_ID)
    if flashlight:failDurabilityCheck(player) then flashlight:updateCondition(-1, player, inv_ID) end
  end
  
  if item then player.inventory:insert(item) end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
   
  local msg = 'You search {with_flashlight} and find {item}.'
  local names = {
    with_flashlight = flashlight_was_used and 'with a flashlight' or '',
    item = item and 'a '..tostring(item) or 'nothing', 
  }
  msg = msg:replace(names)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------     

  local event = {'search', player, item, flashlight_was_used}   
  player.log:insert(msg, event)
end

-------------------------------------------------------------------

local discard = {name='discard', ap={cost=0}}

function discard.activate(player, inv_ID)
  local item = player.inventory:lookup(inv_ID)
  player:remove(inv_ID)
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
    
  local msg = 'You discard a {item}.'
  msg = msg:replace(item)    
    
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------   
  
  local event = {'discard', player, inv_ID}    
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

function item.server_criteria(name, player, inv_ID, ...)
  assert(inv_ID, 'Missing inventory ID for item')
  assert(player.inventory:check(inv_ID), 'Item not in inventory')  
  
  local itemObj = player.inventory:lookup(inv_ID)
  assert(name == itemObj:getClassName(), "Item in inventory doesn't match one being used")

  if itemObj.server_criteria then itemObj.server_criteria(player, ...) end
end

function item.activate(name, player, inv_ID, target)
  local itemObj = player.inventory:lookup(inv_ID)
  local result = itemObj:activate(player, target) 
  
  if itemObj:isSingleUse() and not name == 'syringe' and not name == 'barricade' then 
    player.inventory:remove(inv_ID) 
  elseif name == 'syringe' then -- syringes are a special case
    local antidote_was_created, syringe_was_salvaged = result[2], result[3]
    if antidote_was_created or not syringe_was_salvaged then player.inventory:remove(inv_ID) end
  elseif name == 'barricade' then -- barricades are also a special case
    local did_zombies_interfere = result[1]
    if not did_zombies_interfere then player.inventory:remove(inv_ID) end
  elseif itemObj:failDurabilityCheck(player) then 
    local condition = itemObj:updateCondition(-1, player, inv_ID)
    if condition <= 0 then -- item is destroyed
      player.log:append('Your '..tostring(itemObj)..' is destroyed!')
    elseif itemObj:isConditionVisible(player) then
      player.log:append('Your '..tostring(itemObj)..' degrades to a '..itemObj:getConditionState()..' state.')  
    end    
  end
  --return result (pretty sure we don't need to return the result anymore)
end

-------------------------------------------------------------------

return {search, discard, speak, reinforce, item, equipment}