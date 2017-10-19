local serverOutcome = require('code.player.action.outcome')
local serverCriteria = require('code.player.action.criteria')
local action_list = require('code.player.action.list')
 
local function basicCriteria(player, action)
  local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)  
  assert(AP_cost, 'action has no ap_cost?')  -- remove this assertion once all actions have been added (will be unneccsary)
  assert(ap >= AP_cost, 'not enough ap for action')
  assert(player:isStanding() or action == 'respawn', 'Must be standing for action')
end

local function perform(action, player, ...)
  local mob_type = player:getMobType()
  local action_category = action_list[mob_type][action].category
  
  -- standard check on ALL actions
  local basic_verification, basic_error_msg = pcall(basicCriteria, player, action)
  -- checks to make sure specific action is valid
  local verification, error_msg = pcall(serverCriteria[action_category], action, player, ...) 
  
  if basic_verification and verification then
    local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)    
    serverOutcome[action_category](action, player, ...) -- process the action
    player.condition:elapse(player, AP_cost)   
    player:updateStat('ap', -1*AP_cost)
    player:updateStat('xp', AP_cost)
  else -- Houston, we have a problem!
    player.log:insert(basic_error_msg or error_msg)
  end
  
  --player:updateStat('IP', 1)  -- IP connection hits?  Hmmmm?
end

return perform