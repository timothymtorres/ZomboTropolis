--local outcome = require('code.player.action.outcome')
local dice =              require('code.libs.dice')
local broadcastEvent =    require('code.server.event')

local activate = {}

local GROAN_MAX_RANGE = 6
local GROAN_DENOMINATOR = 3
local groan_description = {'disappointed', 'bored', 'pleased', 'satisfied', 'excited', 'very excited'}

function activate.groan(player)
  local y, x = player:getPos()
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  local groan_range = math.floor(human_n/GROAN_DENOMINATOR + 0.5)
  local range = math.min(groan_range, GROAN_MAX_RANGE)

  broadcastEvent(player, 'You emit a ' .. groan_description[range] .. ' groan.')
  
  local broadcast_settings = {
    for_humans_inside = {
      stage='inside', 
      mob_type='human', 
      exclude={player:getUsername=true}
    },
    for_humans_outside = {
      range=range, 
      stage='outside', 
      mob_type='human'      
    },
    for_zombies_nearby = {
      range=range, 
      mob_type='zombie', 
      exclude={player:getUsername=true}      
    }
  }  
  
  -- What humans will hear
  if player:isStaged('inside') then
    broadcastEvent(p_tile, 'A zombie groans at your current location.', broadcast_settings.for_humans_inside)
  end
  broadcastEvent(p_tile, 'You hear a groan in the distance.', broadcast_settings.for_humans_outside)  -- desc distance based?  [nearby, far away, etc. just like tracking descs]
  
  --What zombies will hear
  broadcastEvent(p_tile, 'You hear a ' .. groan_description[range] .. ' groan at map[' .. y .. ']['.. x .. '].', broadcast_settings.for_zombies_nearby)
  
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
  
  --return {y, x, range} 
end

local DRAG_PREY_HEALTH_THRESHOLD = 13

function activate.drag_prey(player, target)
  local has_been_dragged = DRAG_PREY_HEALTH_THRESHOLD >= target:getStat('hp')
  if has_been_dragged then
    Outcome.exit(player)
    Outcome.exit(target)
    
    broadcastEvent(player, 'You drag '..target:getUsername()..' outside.')
    broadcastEvent(target, 'A zombie drags you outside.')
    
    local broadcast_settings = {
      exclude={player:getUsername()=true, target:getUsername()=true}
    }  
  
    broadcastEvent(player:getTile(), 'A zombie drags '..target:getUsername()..' outside.', broadcast_settings)
  else
    broadcastEvent(player, 'You attempt to drag '..target:getUsername()..' outside but are unsuccessful.')
  end

  -- return {has_been_dragged}
end

function activate.armor(player, armor_type)
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
  --return {armor_type}
end

local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

function activate.gesture(player, target) 
  local object
  
  if type(target) == 'number' then object = compass[target]
  elseif target:getClassName() == 'player' then object = target:getUsername()
  else object = 'the '..target:getName()..' '..target:getClassName() -- must be building
  end
  
  broadcastEvent(player, 'You gesture towards ' .. object .. '.')
  
  local broadcast_settings = {
    stage=player:getStage(), 
    exclude={player:getUsername()=true}
  }  
  
  broadcastEvent(player:getTile(), 'A zombie gestures towards ' .. object .. '.', broadcast_settings)
end

local tracking_description = {
  advanced = {'very far away', 'far away', 'in the distance', 'in the area', 'in a nearby area', 'close', 'very close', 'here'},
  basic = {'far away', 'in the distance', 'in the area', 'close'},
}

function activate.track(player)
  local targets, targets_ranges = player.condition.tracking:getPrey()
  local track_msg = 'You sniff the air for prey.'
  
  if targets then 
    local has_advanced_tracking = player.skills:check('track_adv')  
    for i, target in ipairs(targets) do
      local description = has_advanced_tracking and tracking_description.advanced or tracking_description.basic
      local index = targets_ranges[i]  
      track_msg = track_msg .. '\n' .. target:getUsername() .. ' is ' .. description[index] .. '.'
    end
  else
    track_msg = track_msg .. 'There are no humans you are currently tracking.'
  end
  
  broadcastEvent(player, track_msg)
  
  local broadcast_settings = {
    stage=player:getStage(), 
    exclude={player:getUsername()=true}
  }    
  
  broadcastEvent(player:getTile(), 'A zombie smells the air for prey.', broadcast_settings)
  
  -- return {targets, targets_ranges}
end

local ACID = {
  DEFAULT =   {CHANCE = 0.15, DICE = '1d2'},
  CORRODE =   {CHANCE = 0.20, DICE = '1d3'},
  ACID_ADV =  {CHANCE = 0.30, DICE = '1d4'},
}

function activate.acid(player, target) 
  local n_items = #target.inventory
  local acid_resistance = target.armor:isPresent() and target.armor:getProtection('acid') or 0
  local target_acid_immune = acid_resistance == 4
  
  local acid_type = (player.skills:check('acid_adv') and 'ACID_ADV') or (player.skills:check('corrode') and 'CORRODE') or 'DEFAULT'
  local to_hit_chance = ACID[acid_type].CHANCE
  local acid_successful = to_hit_chance >= math.random()
    
  if acid_successful and not target_acid_immune and n_items > 0 then    
    local acid_dice = dice:new(ACID[acid_type].DICE, 0) - acid_resistance
    for i=n_items, 1, -1 do  -- count backwards due to table.remove being used in item_INST:updateCondition
      local item_INST = target.inventory:lookup(i)
      local acid_damage = acid_dice:roll()      
      
      -- firesuits are immune from acid
      if item_INST:getClassName() ~= 'firesuit' and acid_damage > 0 then item_INST:updateCondition(-1 * acid_damage, target, i) end 
    end
  end 
  
  if acid_successful and target_acid_immune then
    broadcastEvent(player, 'You spray '..target:getUsername()..' with acid but it has no effect.')
    broadcastEvent(target, 'A zombie sprays you with acid but your inventory is protected by a firesuit.')
  elseif acid_successful and n_items == 0 then
    broadcastEvent(player, 'You spray '..target:getUsername()..' with acid but they have no equipment.')
    broadcastEvent(target, 'A zombie sprays you with acid but you have no items in your inventory.')    
  elseif acid_successful then
    broadcastEvent(player, 'You spray '..target:getUsername()..' with acid.')
    broadcastEvent(target, 'A zombie sprays you with acid.')
  else
    broadcastEvent(player, 'You attempt to spray '..target:getUsername()..' with acid but are unsuccessful.')
    broadcastEvent(target, 'A zombie attempts to spray acid at you but is unsuccessful.')
  end  
  
  --return {acid_successful, target_acid_immune}
end

return activate