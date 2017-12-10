local ability = require('code.player.zombie.ability.ability')

local function determineAvailableActions(player)
  local available_actions = {default = {}} -- should our available_actions table have {item={}, ability={}, equipment={}}  how will this look/work?
  local ap = player:getStat('ap')

  for _, action in pairs(player.action_list) do
    if action.name == 'item' then 
      --available_actions.item = {player.inventory:catalog()} -- what to do with ap cost for individual items?
      -- maybe do the inventory catalog in this piece of code
    elseif action.name == 'equipment' then 
      local p_tile = player:getTile()
      
      if p_tile:isBuilding() and p_tile:isPresent('powered equipment') and player:isStaged('inside') then
        for _, machine in ipairs(p_tile:getEquipment()) do
          --[[
          I'm not sure if we are going to make each operation it's own ap cost or just use the machine ap cost for all operations (leaning towards just machine atm)

          local cost = player:getCost('ap', machine.name?  operation.name?   dunno?)
          if machine:hasOperations() and machine.client_criteria and pcall(machine.client_criteria, player) then
            --available_actions.equipment[#available_actions]
          end
          --]]
        end
      end
    elseif action.name == 'ability' then
      --available_actions.ability = {}  ???

      for _, ability in ipairs(ability) do
        local cost = player:getCost('ap', ability.name)        
        if ap >= cost and ability.client_criteria and pcall(ability.client_criteria, player) then -- add an ep cost to the checks?
          --available_actions.ability[#a]
        end
      end
    else
      -- this code has to be run for EVERY action regardless due to ap
      local cost = player:getCost('ap', action.name)   
      if ap >= cost and pcall(action.client_criteria, player) then available_actions.default[#available_actions + 1] = action end

    end
  end

  return available_actions
end

return determineAvailableActions