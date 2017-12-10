local ability = require('code.player.zombie.ability.ability')

local function determineAvailableActions(player, all_actions, check, available_actions)
  local available_actions = {default = {}} -- should our available_actions table have {item={}, ability={}, equipment={}}  how will this look/work?
  local ap = player:getStat('ap')

  for _, action in pairs(player.action_list) do
    local action_name = action.name

    if action_name == 'item' then 
      available_actions.item = {player.inventory:catalog()} -- what to do with ap cost for individual items?
      -- maybe do the inventory catalog in this piece of code
    elseif action_name == 'equipment' then 
      local p_tile = player:getTile()
      
      if p_tile:isBuilding() and p_tile:isPresent('powered equipment') and player:isStaged('inside') then
        for _, machine in ipairs(p_tile:getEquipment()) do
          if machine:hasOperations() and machine.client_criteria and pcall(machine.client_criteria, player) then
            --available_actions.equipment[#available_actions]
          end
        end
      end
    elseif action_name == 'ability' then
      available_actions.ability = {}
      local ability = available_actions.ability

      for _, ability in ipairs(ability) do
        if ability.client_criteria and pcall(ability.client_criteria, player) then available_actions.ability[#a]
    else
      local cost = player:getCost('ap', action_name)   
      if ap >= cost and pcall(action.client_criteria, player) then available_actions.default[#available_actions + 1] = action end
    end
  end

  return available_actions
end

function catalog.location(player)


  return options  
end

return determineAvailableActions