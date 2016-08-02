local serverOutcome = require('code.player.action.outcome')
local serverCriteria = require('code.player.action.criteria')
local broadcastEvent = require('code.server.event')
local getZone = require('code.player.action.zone')
local error_list = require('code.error.list')

local action_category = {
  fields = {'default', 'item', 'skill', 'equipment'},
  default = {'move', 'attack', 'search', 'speak', 'enter', 'exit', 'respawn', 'feed'},
  item = {},
  skill = {'drag_prey', 'groan', 'gesture', 'armor', 'ruin', 'mark_prey', 'track'},
  equipment = {},
}

local function fillActionCategories(list)
  for _, action_type in ipairs(list.fields) do
    for _, action in ipairs(list[action_type]) do
      list[action] = action_type
    end
  end
  return list
end

action_category = fillActionCategories(action_category)
  
local function basicCriteria(player, action)
  local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)  
  assert(AP_cost, 'action has no ap_cost?')  -- remove this assertion once all actions have been added (will be unneccsary)
  assert(ap >= AP_cost, 'not enough ap for action')
  assert(player:isStanding() or action == 'respawn', 'Must be standing for action')
end

local function perform(action, player, ...)
  local action_category_type = action_category[action]
  -- standard checks on ALL actions
  local basic_verification, error_msg = pcall(basicCriteria, player, action)   
  -- checks to make sure action is valid
  local verification, error_msg = pcall(serverCriteria[action_category_type], action, player, ...)
  
  if basic_verification and verification then
    local ap, AP_cost = player:getStat('ap'), player:getCost('ap', action)    
    -- process the action and update stuff (returns a result dependent on action)
    local result = serverOutcome[action_category_type](action, player, ...)
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