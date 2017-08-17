local error_list = require('code.error.list')
local organic_armor_list = require('code.player.armor.organic_list')

local criteria = {}

function criteria.drag_prey(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')
end

error_list[#error_list+1] = 'Must be inside building to drag prey'
error_list[#error_list+1] = 'Must have humans nearby to drag'
error_list[#error_list+1] = 'Building must have an open exit to drag prey'

function criteria.groan(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to groan')
end

error_list[#error_list+1] = 'Must have humans nearby to groan'

function criteria.gesture(player)
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage())
  assert(player_n - 1 > 0, 'Must have players nearby to gesture')
end

error_list[#error_list+1] = 'Must have players nearby to gesture'

function criteria.armor(player, armor_type)
  -- Must recheck EP cost since armor_type not specified in basic criteria EP assert, causing it to be skipped
  local cost, ep = player:getCost('ep', armor_type), player:getStat('ep')
  assert(ep >= cost, 'Not enough enzyme points to use skill')  
  
  local skill = organic_armor_list[armor_type].required_skill
  assert(player.skills:check(skill), 'Must have required skill to use armor ability')
  assert(player.armor:hasRoomForLayer(), 'No remaining room for additional armor layers')
end

error_list[#error_list+1] = 'Not enough enzyme points to use skill'
error_list[#error_list+1] = 'Must have required skill to use armor ability'
error_list[#error_list+1] = 'No remaining room for additional armor layers'

function criteria.ruin(player)
  assert(player:isStaged('inside'), 'Must be inside to ruin building')
end

error_list[#error_list+1] = 'Must be inside to ruin building'

function criteria.mark_prey(player)
  
end

function criteria.track(player)
  assert(player:isStaged('outside'), 'Must be outside to track prey')  
end

error_list[#error_list+1] = 'Must be outside to track prey'

function criteria.acid(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to use acid')  
end

error_list[#error_list+1] = 'Must have humans nearby to use acid'

return criteria