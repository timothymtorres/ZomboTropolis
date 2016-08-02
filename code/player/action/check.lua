local map =         require('code.location.map.class')
local itemCheck = require('code.item.use.check')
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

function check.default(player, action)
  if check[action] then check[action](player) end
end

function check.item(player, item_ID) --, target, inv_ID)
--print(player, item_name, target, inv_ID)
  assert(inv_ID, 'Missing inventory ID for item')
  assert(player.inventory:check(inv_ID), 'Item not in inventory')  
  
  local item, inv_item = lookupItem(item_ID), player.inventory:lookup(inv_ID)
--print(item, inv_item) 
  assert(inv_item:getID() == item:getID(), "Item in inventory doesn't match one being used")
  
  local item_name = item:getClassName()
  if itemCheck[item_name] then itemCheck[item_name](player) end  
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
print('enzyme_list[skill] 1st', skill)
    local cost, ep = player:getCost('ep', skill), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
print('enzyme_list[skill] 2nd', skill)
  end
print('skillcheck[skill] before', skill)
  if skillCheck[skill] then skillCheck[skill](player) end  
print('skillcheck[skill] after', skill)  
end

return check