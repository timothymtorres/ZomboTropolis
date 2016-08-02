local organic_armor_list = require('code.player.armor.organic_list')

local check = {}

function check.drag_prey(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local human_n = p_tile:countPlayers('human', setting)
  assert(setting == 'inside', 'Must be inside building to drag prey')  
  assert(human_n > 0, 'Must have humans nearby to drag')
  --assert(p_tile:isOpen(), 'Building must have an open exit to drag prey')  
end

function check.groan(player)
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  assert(human_n > 0, 'Must have humans nearby to groan')
end

function check.gesture(player)
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage())
  assert(player_n - 1  > 0, 'Must have players nearby to gesture')
end

local MIN_EP_ARMOR_COST = 1  -- this is a bit of a hack

function check.armor(player)
  -- Must recheck EP cost since armor_type not specified in basic criteria EP assert, causing it to be skipped
  local cost, ep = MIN_EP_ARMOR_COST, player:getStat('ep')
  assert(ep >= cost, 'Not enough enzyme points to use skill')  
  
  assert(player.skills:check('armor'), 'Must have required skill to use ability')
  assert(player.armor:hasRoomForLayer(), 'No remaining room for additional armor layers')
end

function check.ruin(player)
  assert(player:isStaged('inside'), 'Must be inside to ruin building')
end

function check.mark_prey(player)
  
end

function check.track(player)
  
end

return check