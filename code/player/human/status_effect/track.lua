local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local tracking = class('tracking')
local TRACKING_TARGET_LIMIT, TRACKING_ADV_TARGET_LIMIT = 5, 8
local TRACKING_TIME, TRACKING_ADV_TIME = '5d20+150', '5d30+200'

function tracking:initialize(player) 
  self.player = player
  self.list = {}
  self.is_tracking = false
end

--------------------------------
--FOR ZOMBIES DOING THE TRACKING
--------------------------------

function tracking:addScent(target)
  local has_advanced_tracking = self.player.skills:check('track_adv')
  local scent_time = (has_advanced_tracking and TRACKING_ADV_TIME) or TRACKING_TIME
  self.is_tracking = true
  
  -- check if target is already on our list
  for i, scent in ipairs(self.list) do
    if scent.prey == target then -- update target to most recent 
      self.list[#self.list+1] = {prey = target, ticks = math.max(dice.roll(scent_time), scent.ticks)}
      table.remove(self.list, i)
      return -- no need for other stuff
    end
  end
  
  self.list[#self.list+1] = {prey = target, ticks = dice.roll(scent_time)}
  target.condition.tracking:addTracker(self.player)
  
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
  if #self.list == 0 then self.is_tracking = false end
end

local tracking_range = {
  advanced = {35, 25, 15, 10, 6, 3, 1, 0},
  basic = {25, 15, 6, 0},
  -- Include ticks_left feature for advanced?  (ie. scent lingers, scent is faint, scent is strong)
}

local function selectTrackingRangeIndex(distance, skill_proficiency)
  for tracking_index, range in ipairs(tracking_range[skill_proficiency]) do
    if distance >= range then return tracking_index end
  end
end

local function getDistanceApart(mob_1, mob_2)
  local x_dist, y_dist = math.abs(mob_1.x - mob_2.x), math.abs(mob_1.y - mob_2.y)
  return math.max(x_dist, y_dist)
end

function tracking:getPrey()
  local prey, tracking_range_indexs
  if self.is_tracking then
    prey, tracking_range_indexs = {}, {}
    for i, scent in ipairs(self.list) do
      local distance, has_advanced_tracking = getDistanceApart(self.player, scent.prey), self.player.skills:check('track_adv')
      local skill_proficiency = has_advanced_tracking and 'advanced' or 'basic'
      prey[#prey+1] = scent.prey
      tracking_range_indexs[#tracking_range_indexs+1] = selectTrackingRangeIndex(distance, skill_proficiency)
    end
  end
  return prey, tracking_range_indexs
end

function tracking:elapse()
  if self.player.isMobType('zombie') and self.is_tracking then
    for i, scent in ipairs(self.list) do
      scent.ticks = scent.ticks - 1      
      if scent.ticks <= 0 then self:removeScent(scent.prey) end
    end
  end
end

--------------------------
--FOR HUMANS BEING TRACKED
--------------------------

function tracking:addTracker(hunter) self.list[hunter] = true end

function tracking:removeTracker(hunter) self.list[hunter] = nil end

function tracking:removeAllTrackers() -- used for scent removal items
  for hunter in pairs(self.list) do hunter.tracking:removeScent(self.player) end
  self.list = {} 
end  

return tracking