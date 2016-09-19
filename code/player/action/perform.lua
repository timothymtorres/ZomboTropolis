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
  -- standard checks on ALL actions
  local basic_verification, error_msg = pcall(basicCriteria, player, action)   
  -- checks to make sure action is valid
  local verification, error_msg = pcall(serverCriteria[action_category], action, player, ...)
  
  if basic_verification and verification then
    local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)    
    -- process the action and update stuff (returns a result dependent on action)
    local result = serverOutcome[action_category](action, player, ...)
    local zone = getZone(action, player, ...) -- may need to change location of getZone (for server events?)
    local params = {player, ...}
  
    if result then -- merge our param table with result
      for _, data in ipairs(result) do params[#params+1] = data end
    end
    -- creates a text event that is sent out to witness (aka players) message logs
    broadcastEvent(zone, action, params)
    
    player.condition:elapse(player, AP_cost)   
    -- update our stats
    player:updateStat('ap', -1*AP_cost)
    player:updateStat('xp', AP_cost)
  else 
    local error_ID = error_list[error_msg]
    player.log:event(os.time(), 'error', error_ID)
    -- player:updateStat('IP', 1)
print(error_msg)
    error(error_msg)    
  end
end

return perform