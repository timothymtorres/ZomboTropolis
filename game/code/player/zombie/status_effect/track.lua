local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local Track = class('Track')
local TRACKING_TARGET_LIMIT, TRACKING_ADV_TARGET_LIMIT = 5, 8
local TRACKING_TIME, TRACKING_ADV_TIME = '5d20+150', '5d30+200'

function Track:initialize(player) 
  self.player = player
  self.scents = {}
end

--------------------------------
--FOR ZOMBIES DOING THE TRACKING
--------------------------------

function Track:addScent(target)
  local has_advanced_tracking = self.player.skills:check('track_adv')
  local scent_time = (has_advanced_tracking and TRACKING_ADV_TIME) or TRACKING_TIME
  
  local biosuit_resistance = target.armor:isPresent() and target.armor:getProtection('bio') or 0
  local biosuit_block_tracking = biosuit_resistance >= 3

  -- biosuits can block tracking if they have a high enough condition
  if biosuit_block_tracking then return end

  -- check if target is already in our scents
  for i, scent in ipairs(self.scents) do
    if scent.prey == target then -- update target to most recent 
      self.scents[#self.scents+1] = {prey = target, ticks = math.max(dice.roll(scent_time), scent.ticks)}
      table.remove(self.scents, i) -- remove prey's old scent from table (the new scent is at the top of the index)
      return -- no need for other stuff
    end
  end
  
  self.scents[#self.scents+1] = {prey = target, ticks = dice.roll(scent_time)}

  if not target.status_effect:isActive('track') then target.status_effect:add('track') end
  target.status_effect.track:addTracker(self.player)
  
  local target_limit = has_advanced_tracking and TRACKING_ADV_TARGET_LIMIT or TRACKING_TARGET_LIMIT
  
  if #self.scents > target_limit then
    local expired_target = self.scents[1].prey
    expired_target.status_effect.track:removeTracker(self.player)
    
    self:removeScent(expired_target) -- double check to make this works?!?
  end
end

function Track:removeScent(target, num)
  for i,scent in ipairs(self.scents) do
    if scent.prey == target  or target == 'all' then 
      scent.ticks = math.max(scent.ticks - num, 0)

      if scent.ticks == 0 then
        local expired_target = scent.prey
        expired_target.status_effect.track:removeTracker(self.player)        
        table.remove(self.scents, i) -- include some kind of notification msg for losing the scent as a zombie? 
      end     
    end
  end
  if #self.scents == 0 then self.player.status_effect:remove('track') end
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

function Track:getPrey()
  local prey, tracking_range_indexs = {}, {}
  for i, scent in ipairs(self.scents) do
    local biosuit_resistance = scent.prey.armor:isPresent() and scent.prey.armor:getProtection('bio') or 0
    local biosuit_block_tracking = biosuit_resistance >= 3

    if not biosuit_block_tracking then 
      local distance = getDistanceApart(self.player, scent.prey)
      local skill_proficiency = self.player.skills:check('track_adv') and 'advanced' or 'basic'
      prey[#prey+1] = scent.prey
      tracking_range_indexs[#tracking_range_indexs+1] = selectTrackingRangeIndex(distance, skill_proficiency)
    end
  end
  return prey, tracking_range_indexs
end

function Track:elapse(time)
  self:removeScent('all', time)
  --[[
  for i, scent in ipairs(self.scents) do
    scent.ticks = scent.ticks - 1      
    if scent.ticks <= 0 then self:removeScent(scent.prey) end
  end
  --]]
end

return Track