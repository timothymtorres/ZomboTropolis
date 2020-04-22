local function determineAvailableActions(player)
  local available_actions = {default = {}} -- should our available_actions table have {item={}, ability={}, equipment={}}  how will this look/work?
  local ap = player.stats:get('ap')

  for _, action in ipairs(player.action_list) do
    if action.name == 'item' then 
      --available_actions.item = {player.inventory:catalog()} -- what to do with ap cost for individual items?
      -- maybe do the inventory catalog in this piece of code
    else
      -- this code has to be run for EVERY action regardless due to ap
      local cost = player:getCost('ap', action.name)   
      if ap >= cost and pcall(action.client_criteria, player) then available_actions.default[#available_actions + 1] = action end

    end
  end

  return available_actions
end

return determineAvailableActions