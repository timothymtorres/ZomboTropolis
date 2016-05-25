local class = require('code.libs.middleclass')
local dice = require('code.libs.rl-dice.dice')

local tracking = class('tracking')
local TRACKING_TARGET_LIMIT, TRACKING_ADV_TARGET_LIMIT = 5, 8
local TRACKING_TIME, TRACKING_ADV_TIME = '5d20+150', '5d30+200'

function tracking:initialize(player) 
  self.player = player
  self.list = {}
end

--------------------------------
--FOR ZOMBIES DOING THE TRACKING
--------------------------------

function tracking:addScent(target)
  local has_advanced_tracking = self.player.skills:check('track_adv')
  local scent_time = (has_advanced_tracking and TRACKING_ADV_TIME) or TRACKING_TIME
  
  -- check if target is already on our list
  for i, scent in ipairs(self.list) do
    if scent.prey == target then -- update target to most recent 
      self.list[#self.list+1] = {prey = target, ticks = math.max(dice.rollAndTotal(scent_time), scent.ticks)}
      table.remove(self.list, i)
      return -- no need for other stuff
    end
  end
  
  self.list[#self.list+1] = {prey = target, ticks = dice.rollAndTotal(scent_time)}
  target.tracking:isMarked(self.player)
  
  local target_limit = has_advanced_tracking and TRACKING_ADV_TARGET_LIMIT or TRACKING_TARGET_LIMIT
  
  if #self.list > target_limit then
    local expired_target = self.list[1].prey
    expired_target.tracking:removeTracker(self.player)
    
    self:removeScent(expired_target) -- double check to make this works?!?
  end
end

function tracking:removeScent(target)
  for i,scent in ipairs(self.list) do
    if scent.prey == target then 
      table.remove(self.list, i)
      -- include some kind of notification msg for losing the scent as a zombie?      
    end
  end
end

local tracking_params = {
  advanced = {
    descriptions = {'very far away', 'far away', 'in the distance', 'in the area', 'in a nearby area', 'close', 'very close', 'here'},
    range = {35, 25, 15, 10, 6, 3, 1, 0},
    --TICKS_LEFT FOR ADVANCED?  DETERMINE HOW MUCH TIME SCENT HAS REMAINING (later feature)
    --ticks_left = {'the scent is...' 'scarce', 'lingers', 'light', 'heavy'},
  },
  basic = {
    descriptions = {'far away', 'in the distance', 'in the area', 'close'},
    range = {25, 15, 6, 3},
  },
}

-- You sniff the air for prey.
-- John Doe is [desc]. 

local function selectTrackingMessage(distance, params)
  for i, range in ipairs(params.range) do
    if distance >= range then return params.descriptions[i] end
  end
end

local function getDistanceApart(mob_1, mob_2)
  local x_dist, y_dist = math.abs(mob_1.x - mob_2.x), math.abs(mob_1.y - mob_2.y)
  return math.max(x_dist, y_dist)
end

function tracking:getScentDesc()
  local track_msgs = {'You sniff the air for prey.'}
  for i, scent in ipairs(self.list) do
    local distance, has_advanced_tracking = getDistanceApart(self.player, scent.prey), self.player.skills:check('track_adv')
    local params = has_advanced_tracking and tracking_params.advanced or tracking_params.basic
    track_msgs[#track_msgs+1] = scent.prey:getUserName()..' is '..selectTrackingMessage(distance, params)..'.'
  end
end

function tracking:elapse()
  if self.player.isMobType('zombie') then
    for i, scent in ipairs(self.list) do
      scent.ticks = scent.ticks - 1      
      if scent.ticks <= 0 then self:removeScent(scent.prey) end
    end
  end
end

--------------------------
--FOR HUMANS BEING TRACKED
--------------------------

function tracking:beingTracked(hunter) self.list[hunter] = true end

function tracking:removeTracker(hunter) self.list[hunter] = nil end

function tracking:removeAllTrackers() -- used for scent removal items
  for hunter in pairs(self.list) do hunter.tracking:removeScent(self.player) end
  self.list = {} 
end  

return tracking