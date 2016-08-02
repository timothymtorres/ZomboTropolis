local actionCheck = require('code.player.action.check')
local equipmentCheck = require('code.location.building.equipment.operation.check')
local skillCheck = require('code.player.skills.check')
local action_list = require('code.player.action.list')
local enzyme_list = require('code.player.enzyme_list')

local catalog = {}

local function determineAvailableActions(player, all_actions, check, available_actions)
  available_actions = available_actions or {}  
  local ap = player:getStat('ap')
  
  for action in pairs(all_actions) do
print('determine action - ', action)
    local cost = player:getCost('ap', action)   
    if ap >= cost then
      local action_passed_requirements, fail_msg = pcall(check, player, action) --check(player, action)
print(action_passed_requirements, fail_msg)
      if action_passed_requirements then available_actions[#available_actions + 1] = action end
    end
  end
  return available_actions
end

function catalog.item(player)
  return player.inventory:catalog() 
end

function catalog.ability(player)
  local mob_type = player:getMobType()
  local options = determineAvailableActions(player, action_list.info[mob_type].skill, actionCheck.skill) --skillCheck)
  
  return options  
end

function catalog.location(player)
  local mob_type = player:getMobType()
  local options = determineAvailableActions(player, action_list.info[mob_type].basic, actionCheck.default)
  local p_tile = player:getTile()
  
  if p_tile:isBuilding() and p_tile:isPresent('powered equipment') and player:isStaged('inside') then
    for machine in pairs(p_tile:getEquipment()) do
      if p_tile[machine]:hasOperations() then
        options = determineAvailableActions(player, p_tile[machine]:getOperations(), equipmentCheck[machine], options)
      end
    end
  end

  return options  
end

return catalog