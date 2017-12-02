local enzyme_list =       require('code.player.enzyme_list')
local dice =              require('code.libs.dice')
local broadcastEvent =    require('code.server.event')
string.replace =          require('code.libs.replace')

-------------------------------------------------------------------

local respawn = {name='respawn'}

function respawn.client_criteria(player) assert(not player:isStanding(), 'Must be dead for action') end  

function respawn.server_criteria(player) assert(not player:isStanding(), 'You are already standing') end

function respawn.activate(player) 
  player:respawn()  
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg = 'A nearby corpse rises to life'
  local self_msg = player.skills:check('hivemind') and 'You animate to life quickly and stand.' or 'You reanimate to life and struggle to stand.'  
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'respawn', player}  
  player:broadcastEvent(msg, self_msg, event)    
end

-------------------------------------------------------------------

local ransack = {name='ransack'}

function ransack.client_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to ransack')
  assert(player:isStaged('inside'), 'Player must be inside building to ransack')
  
  local can_ransack_building = p_tile.integrity:canModify(player)
  assert(can_ransack_building, 'Unable to ransack building in current state')
end

function ransack.server_criteria(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to ransack')
  assert(player:isStaged('inside'), 'Player must be inside building to ransack')
  
  local can_ransack_building = p_tile.integrity:canModify(player)
  assert(can_ransack_building, 'Unable to ransack building in current state')
end

function ransack.activate(player)
  local ransack_dice = dice:new('2d3')
  if player.skills:check('ransack') then ransack_dice = ransack_dice / 1 end
  if player.skills:check('ruin') then ransack_dice = ransack_dice ^ 4 end
  
  local building = player:getTile()
  building.integrity:updateHP(-1 * ransack_dice:roll() )
  local integrity_state = building.integrity:getState()
  local building_was_ransacked = integrity_state == 'ransacked'  --local building_was_ruined = integrity_state == 'ruined'
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg =      'A zombie {destruction} the building.'
  local self_msg = 'You {destruction} the building.'  
  local destruction_type = building_was_ransacked and 'ransack' or 'ruin'
  
  self_msg = self_msg:replace(destruction_type)
  msg =           msg:replace(destruction_type..'s')
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------  
  
  local event = {'ransack', player, integrity_state}  
  player:broadcastEvent(msg, self_msg, event)  
end

-------------------------------------------------------------------

local feed = {name='feed'}

function feed.client_criteria(player)
  local p_tile, p_stage = player:getTile(), player:getStage()
  local corpse_n = p_tile:countCorpses(p_stage)
  assert(corpse_n > 0, 'No available corpses to eat')
  
  local edible_corpse_present 
  local tile_player_group = p_tile:getPlayers(p_stage)
  for tile_player in pairs(tile_player_group) do
    if not tile_player:isStanding() and tile_player.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')   
end

function feed.server_criteria(player)
  local p_tile, p_stage = player:getTile(), player:getStage()
  local corpse_n = p_tile:countCorpses(p_stage)
  assert(corpse_n > 0, 'No available corpses to eat')
  
  local edible_corpse_present 
  local tile_player_group = p_tile:getPlayers(p_stage)
  for tile_player in pairs(tile_player_group) do
    if not tile_player:isStanding() and tile_player.carcass:edible(player) then
      edible_corpse_present = true
      break
    end
  end
  assert(edible_corpse_present, 'All corpses have been eaten')  
end

local corpse_effects = { 
  -- First come, first serve! (less xp and decay loss as corpse becomes more devoured)
  xp = {'1d10+5', '1d9+3', '1d7+2', '1d5+1', '1d3',
    digestion = {'1d18+12', '1d16+8', '1d12+6', '1d8+4', '1d4+2'},
  },  
  decay = {'1d200+300', '1d200+250', '1d200+200', '1d200+150', '1d200+100',
    digestion = {'1d400+600', '1d400+500', '1d400+400', '1d400+300', '1d400+200'},
  },
}

function feed.activate(player) 
  local p_tile, p_stage = player:getTile(), player:getStage()
  local tile_player_group = p_tile:getPlayers(p_stage)
  local target
  local lowest_scavenger_num = 5
  
  -- finds the corpse with the lowest number of scavengers (fresh meat) 
  for tile_player in pairs(tile_player_group) do
    local corpse_scavenger_num = #tile_player.carcass.carnivour_list
    if not tile_player:isStanding() and tile_player.carcass:edible(player) and lowest_scavenger_num > corpse_scavenger_num then
      target = tile_player
      lowest_scavenger_num = corpse_scavenger_num 
    end
  end
  
  local nutrition_lvl = target.carcass:devour(player)
  local xp_gained, decay_loss
  if player.skills:check('digestion') then 
    xp_gained = corpse_effects.xp.digestion[nutrition_lvl]
    decay_loss = corpse_effects.decay.digestion[nutrition_lvl]
  else
    xp_gained = corpse_effects.xp[nutrition_lvl]
    decay_loss = corpse_effects.decay[nutrition_lvl]
  end
  
  xp_gained, decay_loss = dice.roll(xp_gained), dice.roll(decay_loss)
    
  player:updateStat('xp', xp_gained)
  player.condition.decay:add(-1*decay_loss) 
  
  --------------------------------------------
  -----------   M E S S A G E   --------------
  --------------------------------------------
  
  local msg, self_msg = 'A zombie feeds on a corpse.', 'You feed on a corpse.'
  
  --------------------------------------------
  ---------   B R O A D C A S T   ------------
  --------------------------------------------
  
  local event = {'feed', player}  
  player:broadcastEvent(msg, self_msg, event)   
end

-------------------------------------------------------------------

local ability = {name='ability'}

function ability.client_criteria(name, player) --, target)
  assert(player.skills:check(name), 'Must have required skill to use ability')
  if enzyme_list[name] then
    local cost, ep = player:getCost('ep', name), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end
  if skillCheck[name] then skillCheck[name](player) end   -- we need to require ability.client_criteria this
end

function ability.server_criteria(name, player, ...)
--for k,v in pairs(player) do print(k,v) end
  assert(player.skills:check(name), 'Must have required skill to use ability')
  if enzyme_list[name] then
    local cost, ep = player:getCost('ep', name), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end  
  if skillCriteria[name] then skillCriteria[name](player, ...) end 
end

function ability.activate(name, player, target)
  if enzyme_list[name] then
    local cost = player:getCost('ep', name)
    player:updateStat('ep', cost)
  end    
  return skillActivate[name](player, target)  
end

return {respawn, ransack, feed, ability}