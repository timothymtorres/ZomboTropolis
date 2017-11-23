local Map =         require('code.location.map')
local equipmentCheck = require('code.location.building.equipment.operation.check')
local skillCheck = require('code.player.skills.check')
local enzyme_list = require('code.player.enzyme_list')

local check = {}

function check.respawn(player) assert(not player:isStanding(), 'Must be dead for action') end  

function check.attack(player)
  local player_targets, building_targets  
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1  -- subtract one from total b/c player on tile 
  
  if player_n > 0 then player_targets = true end
  if p_tile:isBuilding() then
    if p_tile:isFortified() then building_targets = true end
    if p_tile:isPresent('equipment') then building_targets = true end
  end
  assert(player_targets or building_targets, 'No available targets to attack')
end

--function check.search() return true end  No need for this check?

function check.barricade(player) -- later check if player has barricade materials or building has room for cade? 
  local p_tile = player:getTile() 
  assert(p_tile:isBuilding() and player:isStaged('inside'), 'Must be inside building to barricade')
  assert(p_tile.barricade:roomForFortification(), 'There is no room available for fortifications')
  assert(p_tile.barricade:canPlayerFortify(player), 'Unable to make stronger fortification without required skills')
  assert(not p_tile.integrity:isState('ruined'), 'Unable to make fortifications in a ruined building')    
end

function check.reinforce(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to reinforce')
  assert(player:isStaged('inside'), 'Player must be inside building to reinforce')
  assert(not p_tile.integrity:isState('ruined'), 'Unable to reinforce a ruined building')
  assert(p_tile.barricade:canReinforce(), 'No room for reinforcements in building')
  assert(player.skills:check('reinforce'), 'Must have skill to reinforce building')
end

function check.speak(player) 
  if player:isMobType('zombie') then assert(player.skills:check('speech'), 'Must have "speech" skill to speak') end
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1
  assert(player_n > 0, 'No available players to speak to')
end

function check.feed(player)
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

function check.ransack(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to ransack')
  assert(player:isStaged('inside'), 'Player must be inside building to ransack')
  
  local can_ransack_building = p_tile.integrity:canModify(player)
  assert(can_ransack_building, 'Unable to ransack building in current state')
end

function check.default(player, action)
  if check[action] then check[action](player) end
end

function check.equipment(player, equipment_name) -- operation)
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  
  -- add p_tile to vars?
  if equipmentCheck[equipment_name] then equipmentCheck[equipment_name](player) end  
end

function check.skill(player, skill) --, target)
  assert(player.skills:check(skill), 'Must have required skill to use ability')
  if enzyme_list[skill] then
    local cost, ep = player:getCost('ep', skill), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end
  if skillCheck[skill] then skillCheck[skill](player) end   
end

return check