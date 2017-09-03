local serverOutcome = require('code.player.action.outcome')
local serverCriteria = require('code.player.action.criteria')
local broadcastEvent = require('code.server.event')
local getZone = require('code.player.action.zone')
local error_list = require('code.error.list')
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

  local basic_verification= pcall(basicCriteria, player, action) -- standard checks on ALL actions
  local verification = pcall(serverCriteria[action_category], action, player, ...) -- checks to make sure action is valid
  
  if basic_verification and verification then
    local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)    
    serverOutcome[action_category](action, player, ...) -- process the action
    player.condition:elapse(player, AP_cost)   
    player:updateStat('ap', -1*AP_cost)
    player:updateStat('xp', AP_cost)
  end
  
  --player:updateStat('IP', 1)  -- IP connection hits?  Hmmmm?
end

return perform