local map =         require('code.location.map.class')
local equipmentCriteria = require('code.location.building.equipment.operation.criteria')
local skillCriteria = require('code.player.skills.criteria')
local enzyme_list = require('code.player.enzyme_list')

local criteria = {}

local function getNewPos(y, x, dir)
--[[
  +-------+
  ||8|1|2||
  ||7| |3||
  ||6|5|4||
  +-------+
--]]

  local dir_y, dir_x
  if dir == 1 then dir_x = x dir_y = y-1
  elseif dir == 2 then dir_x = x + 1 dir_y = y - 1
  elseif dir == 3 then dir_x = x + 1 dir_y = y
  elseif dir == 4 then dir_x = x + 1 dir_y = y + 1
  elseif dir == 5 then dir_x = x     dir_y = y + 1
  elseif dir == 6 then dir_x = x - 1 dir_y = y + 1
  elseif dir == 7 then dir_x = x - 1 dir_y = y
  elseif dir == 8 then dir_x = x - 1 dir_y = y - 1
  end
  return dir_y, dir_x
end

function criteria.move(player, dir)
  assert(dir, 'Cannot move without direction')  
  local y, x = player:getPos()
  local map = player:getMap()
  local dir_y, dir_x = getNewPos(y, x, dir)
  local outside_map = dir_y > #map or dir_y < 1 or dir_x > #map or dir_x < 1
  assert(not outside_map, 'Cannot move outside the quarantine')
end

function criteria.attack(player, target, weapon, inv_ID)
-- Weapon/Inventory checks [start]
  local organic_weapon = weapon:isOrganic()

  if organic_weapon then 
    assert(organic_weapon == player:getMobType(), 'Cannot use this attack')
    assert(not inv_ID, "Organic weapon shouldn't be in inventory")
    if weapon:isSkillRequired() then
      local weapon_skill_present = player.skills:check(weapon:getSkillRequired())
      assert(weapon_skill_present, 'Cannot use this attack without required skill')
    end
  else -- Weapon is NOT organic
    assert(player:isMobType('human'), 'Must be human to attack with items')
    assert(weapon and inv_ID, 'Weapon not selected properly')
    assert(player.inventory:check(inv_ID), 'Weapon missing from inventory')    
    
    local inv_item = player.inventory:lookup(inv_ID) 
    assert(inv_item:getFlag() == weapon:getFlag(), "Inventory item doesn't match weapon")    
  end
-- Weapon/Inventory checks [finish]
  
  local p_tile = player:getTile()
  local target_class = target:getClassName()
--print('target_class', target_class, target)

  if target_class == 'player' then
    -- need to check if target actually exists in player database... aka - target:isPresent()?!
    assert(target:isStanding(), 'Target has been killed')
    local t_tile = target:getTile()
    assert(p_tile == t_tile and player:getStage() == target:getStage(), 'Target has moved out of range')
  elseif target_class == 'equipment' then
    assert(p_tile:isBuilding(), 'No building present to target equipment for attack')
    assert(player:isStaged('inside'), 'Player must be inside building to attack equipment')
    assert(weapon:getObjectDamage('equipment'), 'Selected weapon unable to attack equipment')
    assert(p_tile[target_class]:isPresent(), 'Equipment target does not exist in building')     
  else -- target_class == 'building' then
    assert(p_tile:isBuilding(), 'No building near player to attack')
    assert(weapon:getObjectDamage('barricade'), 'Selected weapon cannot attack barricade') -- fix this later (check for door too!)
    assert(p_tile:isFortified(), 'No barricade or door on building to attack')
  end
end

function criteria.search(player) end

function criteria.speak(player, message) --, target) 
  local p_tile = player:getTile()
  local player_n = p_tile:countPlayers('all', player:getStage()) - 1
  assert(player_n > 0, 'No players nearby to communicate')       
  assert(message, 'Must have a message to speak')
  assert(type(message) == 'string', 'Message must be a string')
  assert(string.len(message) < 255, 'Message length too long')
     
--[[  This is a later feature used for whispering to a single person     
  assert(target, 'Must have a target to speak')      
  local target_class = target:getClassName()
  if target_class == 'player' then
    local p_spot, t_spot = player:getSpot(), target:getSpot()
    assert(target:isStanding(), 'target has been killed')
    assert(p_spot == t_spot, 'target has moved out of range, error #3')  
  end
--]]  
end

function criteria.reinforce(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to reinforce')
  assert(player:isStaged('inside'), 'Player must be inside building to reinforce')
  assert(not p_tile.integrity:isState('ruined'), 'Unable to reinforce a ruined building')
  assert(p_tile.barricade:canReinforce(), 'No room for reinforcements in building')
  assert(player.skills:check('reinforce'), 'Must have skill to reinforce building')  
end

function criteria.feed(player)
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

function criteria.enter(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to enter')
  assert(player:isStaged('outside'), 'Player must be outside building to enter')
end

function criteria.exit(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to exit')
  assert(player:isStaged('inside'), 'Player must be inside building to exit')
end

function criteria.respawn(player)
  assert(not player:isStanding(), 'You are already standing')
end

function criteria.ransack(player)
  local p_tile = player:getTile()
  assert(p_tile:isBuilding(), 'No building nearby to ransack')
  assert(player:isStaged('inside'), 'Player must be inside building to ransack')
  
  local can_ransack_building = p_tile.integrity:canModify(player)
  assert(can_ransack_building, 'Unable to ransack building in current state')
end

function criteria.default(action, player, ...)
  if criteria[action] then criteria[action](player, ...) end
end

function criteria.item(item_name, player, inv_ID, ...)
  assert(inv_ID, 'Missing inventory ID for item')
  assert(player.inventory:check(inv_ID), 'Item not in inventory')  
  
  local item = player.inventory:lookup(inv_ID)
  assert(item_name == item:getClassName(), "Item in inventory doesn't match one being used")
  
  if item.server_criteria then item:server_criteria(player, ...) end
end

function criteria.equipment(equipment, player, operation)
  assert(operation, 'Missing equipment operation for action')
  
  local p_tile = player:getTile()  
  assert(p_tile:isBuilding(), 'No building near player to use equipment')
  assert(player:isStaged('inside'), 'Player is not inside building to use equipment')
  assert(p_tile:isPowered(), 'Building must be powered to use equipment')
  
  -- add p_tile to vars?
  if equipmentCriteria[equipment] then equipmentCriteria[equipment](player, operation) end  
end

function criteria.skill(skill, player, ...)
--for k,v in pairs(player) do print(k,v) end
  assert(player.skills:check(skill), 'Must have required skill to use ability')
  if enzyme_list[skill] then
    local cost, ep = player:getCost('ep', skill), player:getStat('ep')
    assert(ep >= cost, 'Not enough enzyme points to use skill')
  end  
  if skillCriteria[skill] then skillCriteria[skill](player, ...) end 
end

return criteria