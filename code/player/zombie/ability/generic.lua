--local organic_armor_list = require('code.player.armor.organic_list')

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


return client_criteria