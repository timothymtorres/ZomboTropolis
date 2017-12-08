local dice =              require('code.libs.dice')
local broadcastEvent =    require('code.server.event')
local organic_armor_list = require('code.player.armor.organic_list')

-------------------------------------------------------------------

local drag_prey = {name='drag_prey'}

function drag_prey.client_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')  
end

function drag_prey.server_criteria(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')
end

local DRAG_PREY_HEALTH_THRESHOLD = 13

function drag_prey.activate(player, target)
  local has_been_dragged = DRAG_PREY_HEALTH_THRESHOLD >= target:getStat('hp')
  
  if has_been_dragged then
    local y, x = player:getPos()
    local map = player:getMap()
    map[y][x]:remove(player, 'inside')
    map[y][x]:insert(player, 'outside') 
    
    map[y][x]:remove(target, 'inside')
    map[y][x]:insert(target, 'outside')    
  end
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg, msg
  
  if has_been_dragged then
    self_msg =   'You drag {target} outside.'
    target_msg = 'A zombie drags you outside.'
    msg =        'A zombie drags {target} outside.'  
  else
    self_msg =   'You attempt to drag {target} outside but are unsuccessful.'    
  end
  
  self_msg = self_msg:replace(target)
  msg =   msg and msg:replace(target)
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  

  local event = {'drag_prey', player, target, has_been_dragged}  

  if has_been_dragged then
    local tile = player:getTile()    
    local settings = {exclude={}}  
    settings.exclude[player], settings.exclude[target] = true, true
    tile:broadcastEvent(msg, event, settings)
  else
    player.log:insert(self_msg, event)    
  end
end

-------------------------------------------------------------------

local groan = {name='groan'}

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
  local y, x = player:getPos()
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

local gesture = {name='gesture'}

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

local armor = {name='armor'}

local MIN_EP_ARMOR_COST = 1  -- this is a bit of a hack

function armor.client_criteria(player)
  -- Must reclient_criteria EP cost since armor_type not specified in basic criteria EP assert, causing it to be skipped
  local cost, ep = MIN_EP_ARMOR_COST, player:getStat('ep')
  assert(ep >= cost, 'Not enough enzyme points to use skill')  
  
  assert(player.skills:client_criteria('armor'), 'Must have required skill to use ability')
  assert(player.armor:hasRoomForLayer(), 'No remaining room for additional armor layers')
end

function armor.server_criteria(player, armor_type)
  -- Must recheck EP cost since armor_type not specified in basic server_criteria EP assert, causing it to be skipped
  local cost, ep = player:getCost('ep', armor_type), player:getStat('ep')
  assert(ep >= cost, 'Not enough enzyme points to use skill')  
  
  local skill = organic_armor_list[armor_type].required_skill
  assert(player.skills:check(skill), 'Must have required skill to use armor ability')
  assert(player.armor:hasRoomForLayer(), 'No remaining room for additional armor layers')
end

function armor.activate(player, armor_type)
  player.armor:equip(armor_type)  -- return # of layers?
  
--[[  Planning on redoing the armor code so these msgs will probably change  
  if armor_type == 'scale' then
    msg[1] = 'Your skin shapeshifts into hard scales that are resistant to bladed weapons.'  
  elseif armor_type == 'blubber' then
    msg[1] = 'Your body shapeshifts into a blubbery mass that is skilled at absorbing blunt weapon impacts.'
  elseif armor_type == 'gel' then
    msg[1] = 'Your body oozes goo out of various pores that is effective at absorbing heat.'
  elseif armor_type == 'sticky' then
    msg[1] = 'Your body secretes slime causing the various armor layers to become more resillent.'
  elseif armor_type == 'stretch' then
    msg[1] = 'Your skin becomes loose and rubbery causing projectiles to slow as they make contact.'
  end
--]]  
end

-------------------------------------------------------------------

local ransack = {name='ransack'}

function ransack.client_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside to ransack building')
end

function ransack.server_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside to ransack building')
end

-------------------------------------------------------------------

local mark_prey = {name='mark_prey'}

function mark_prey.client_criteria(player)
  
end

function mark_prey.server_criteria(player)
  
end

-------------------------------------------------------------------

local track = {name='track'}

function track.client_criteria(player)
   assert(player:isStaged('outside'), 'Must be outside to track prey')   
end

function track.server_criteria(player)
  assert(player:isStaged('outside'), 'Must be outside to track prey')  
end

local tracking_description = {
  advanced = {'very far away', 'far away', 'in the distance', 'in the area', 'in a nearby area', 'close', 'very close', 'here'},
  basic = {'far away', 'in the distance', 'in the area', 'close'},
}

function track.activate(player)  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local targets, targets_ranges = player.condition.tracking:getPrey()
  
  local self_msg = 'You sniff the air for prey.'
  local msg = 'A zombie smells the air for prey.'
  
  if targets then 
    local has_advanced_tracking = player.skills:check('track_adv')  
    for i, target in ipairs(targets) do
      local description = has_advanced_tracking and tracking_description.advanced or tracking_description.basic
      local index = targets_ranges[i]  
      self_msg = self_msg .. '\n' .. target .. ' is ' .. description[index] .. '.'
    end
  else
    self_msg = self_msg .. 'There are no humans you are currently tracking.'
  end  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'track', player}
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

local acid = {name='acid'}

function acid.client_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to use acid')  
end

function acid.server_criteria(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to use acid')  
end

local ACID = {
  DEFAULT =   {CHANCE = 0.15, DICE = '1d2'},
  CORRODE =   {CHANCE = 0.20, DICE = '1d3'},
  ACID_ADV =  {CHANCE = 0.30, DICE = '1d4'},
}

function acid.activate(player, target) 
  local n_items = #target.inventory
  local acid_resistance = target.armor:isPresent() and target.armor:getProtection('acid') or 0
  local target_acid_immune = acid_resistance == 4
  
  local acid_type = (player.skills:check('acid_adv') and 'ACID_ADV') or (player.skills:check('corrode') and 'CORRODE') or 'DEFAULT'
  local to_hit_chance = ACID[acid_type].CHANCE
  local acid_successful = to_hit_chance >= math.random()
  
  local destroyed_items, damaged_items = {}, {}
    
  if acid_successful and not target_acid_immune and n_items > 0 then    
    local acid_dice = dice:new(ACID[acid_type].DICE, 0) - acid_resistance
    for inv_ID=n_items, 1, -1 do  -- count backwards due to table.remove being used in item_INST:updateCondition
      local item_INST = target.inventory:lookup(inv_ID)
      local acid_damage = acid_dice:roll()      
      
      -- firesuits are immune from acid
      if item_INST:getClassName() ~= 'firesuit' and acid_damage > 0 then 
        local condition 
        if itemObj:isSingleUse() then condition = 0 
        else condition = item_INST:updateCondition(-1 * acid_damage)
        end

        if condition <= 0 then 
          destroyed_items[#destroyed_items + 1] = item_INST -- item was destroyed
          target.inventory:remove(inv_ID)
        else                   
          damaged_items[#damaged_items + 1]     = item_INST -- item was damaged  
        end        
      end 
    end
  end 
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local self_msg, target_msg 
  
  if acid_successful and target_acid_immune then
    self_msg =   'You spray {target} with acid but it has no effect.'
    target_msg = 'A zombie sprays you with acid but your inventory is protected by a firesuit.'
  elseif acid_successful and n_items == 0 then
    self_msg =   'You spray {target} with acid but they have no equipment.'
    target_msg = 'A zombie sprays you with acid but you have no items in your inventory.'  
  elseif acid_successful then
    self_msg =   'You spray {target} with acid.'
    target_msg = 'A zombie sprays you with acid.'
  else
    self_msg =   'You attempt to spray {target} with acid but are unsuccessful.'
    target_msg = 'A zombie attempts to spray acid at you but is unsuccessful.'
  end  
  
  self_msg = self_msg:replace(target)
  
  for _, damaged_item_INST in ipairs(damaged_items) do
    self_msg = self_msg..'  The '..tostring(damaged_item_INST)..' was damaged.'
    if damaged_item_INST:isConditionVisible(target) then
      target_msg = target_msg..'  Your '..tostring(damaged_item_INST)..' degrades to a '..damaged_item_INST:getConditionState()..' state.'
    else
      target_msg = target_msg..'  Your '..tostring(damaged_item_INST)..' was damaged.'
    end
  end
  
  for _, destroyed_item_INST in ipairs(destroyed_items) do
    self_msg = self_msg..'  The '..tostring(destroyed_item_INST)..' was destroyed!'
    target_msg = target_msg..'  Your '..tostring(destroyed_item_INST)..' was destroyed!'
  end  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'acid', player, target, acid_successful, target_acid_immune}    
  player.log:insert(self_msg, event)
  target.log:insert(target_msg, event)  
end

return {drag_prey, groan, gesture, armor, ransack, mark_prey, track, acid}