--local outcome = require('code.player.action.outcome')
local dice =              require('code.libs.dice')

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

function activate.track(player)
  local targets, targets_ranges = player.condition.tracking:getPrey()
  return {targets, targets_ranges}
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
    
  if acid_successful and not target_acid_immune then    
    local acid_dice = dice:new(ACID[acid_type].DICE) - acid_resistance
    for i, n_items in ipairs(target.inventory) do
      local item_INST = target.inventory:lookup(i)
      local acid_damage = -1 * acid_dice:roll()
      item_INST:updateCondition(acid_damage, player, i) 
    end
  end 
  
  return {acid_successful, target_acid_immune}
end

return activate