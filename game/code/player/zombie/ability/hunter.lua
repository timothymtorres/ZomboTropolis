local dice = require('code.libs.dice')
local broadcastEvent = require('code.server.event')

-------------------------------------------------------------------

local mark_prey = {name='mark_prey', ap={cost=1}}

function mark_prey.client_criteria(player)
  
end

function mark_prey.server_criteria(player)
  
end

-------------------------------------------------------------------

local track = {name='track', ap={cost=1}}

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
  
  local targets, targets_ranges = player.status_effect:isActive('track') and player.status_effect.track:getPrey()
  
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

local hide = {name='hide', ap={cost=3, modifier={hide_adv = -2}}}

function hide.client_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside building to hide')
  local p_tile = player:getTile()
  assert(p_tile:countPlayers('human', 'inside') == 0, 'Unable to hide with humans nearby')
  assert(not p_tile:isPowered(), 'Unable to hide inside a powered building')
end

function hide.server_criteria(player)
  assert(player:isStaged('inside'), 'Must be inside building to hide')
  local p_tile = player:getTile()
  assert(p_tile:countPlayers('human', 'inside') == 0, 'Unable to hide with humans nearby')
  assert(not p_tile:isPowered(), 'Unable to hide inside a powered building')
end

local HIDE_CHANCE, HIDE_ADV_CHANCE = 0.35, 0.50
local RUIN_BONUS_CHANCE = 0.10

function hide.activate(player)  
  local base_chance = player.skills:check('hide_adv') and HIDE_ADV_CHANCE or HIDE_CHANCE
  local p_tile = player:getTile()
  if p_tile:isIntegrity('ruined', player:getStage()) then base_chance = base_chance + RUIN_BONUS_CHANCE end

  local is_hidden = false

  if base_chance >= math.random() then
    is_hidden = true
    player.status_effect:add('hide')
  end

  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------

  local msg =      'A zombie {hidden} in the building.'
  local self_msg = 'You {hidden} in the building.'  
  local hidden = is_hidden and 'hide' or 'fail to hide'
  
  self_msg = self_msg:replace(hidden)
  msg =           msg:replace(hidden..'s')
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------

  local event = {'hide', player, is_hidden}

  if is_hidden then player:broadcastEvent(msg, self_msg, event)  
  else player.log:insert(self_msg, event)
  end
end

-------------------------------------------------------------------

return {mark_prey, track, hide}