--local outcome = require('code.player.action.outcome')

local activate = {}

local GROAN_MAX_RANGE = 6
local GROAN_DENOMINATOR = 3

function activate.groan(player)
  local y, x = player:getPos()
  local p_tile = player:getTile()
  local human_n = p_tile:countPlayers('human', player:getStage())
  local groan_range = math.floor(human_n/GROAN_DENOMINATOR + 0.5)
  local range = math.min(groan_range, GROAN_MAX_RANGE)
  return {y, x, range} 
end

local DRAG_PREY_HEALTH_THRESHOLD = 13

function activate.drag_prey(player, target)
  local has_been_dragged = DRAG_PREY_HEALTH_THRESHOLD >= target:getStat('hp')
  if has_been_dragged then
    Outcome.exit(player)
    Outcome.exit(target)
  end  
  return {has_been_dragged}
end

function activate.armor(player, armor_type)
  player.armor:equip(armor_type)  -- return # of layers?
  return {armor_type}
end

function activate.gesture(player, target) end

return activate