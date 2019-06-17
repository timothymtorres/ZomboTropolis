local lume = require('code.libs.lume')
local loadMobTilesets = require('scenes.functions.loadMobTilesets')

local mob_tilesets = loadMobTilesets('graphics/mob')

local MOVEMENT_DELAY = 7

local function Plugin(mob)	
--[[
  mob is a snapshot
  mob.group[1] & mob.group[2] are the name/name_background

  mob.movement_timer     -- used to roam around map under a recurring timer
  mob.action_timer       -- used to repeat actions (tap&hold)
  mob.transition_ID      -- used to track transitions involving mob
  mob.current_action     -- string value of the current action
  mob.last_x, mob.last_y -- saves last position before action taken
--]]

  function mob:setSequence(animation)
    self:invalidate()
    for i=3, self.group.numChildren do
      self.group[i]:setSequence(animation)
    end
  end

  function mob:play()
    for i=3, self.group.numChildren do
       self.group[i]:play() 
    end
  end

  function mob:updateDirection(x, y) 
    local x_distance, y_distance = x - self.x, y - self.y
    local dir 

    if math.abs(x_distance) < math.abs(y_distance) and y_distance < 0 then 
      dir = "north"
    elseif math.abs(x_distance) >= math.abs(y_distance) and x_distance >= 0 then
      dir = "east"
    elseif math.abs(x_distance) < math.abs(y_distance) and y_distance >= 0 then
      dir = "south"
    elseif math.abs(x_distance) >= math.abs(y_distance) and x_distance < 0 then 
      dir = "west"
    end

    mob:setSequence("walk-"..dir)  -- changes direction 
  end

  function mob:pauseMotion()
    self:setLinearVelocity(0, 0) 
    self.isBodyActive = false
  end

  function mob:resumeMotion() self.isBodyActive = true end

  function mob:wait() self:setLinearVelocity(0, 0) end

  function mob:roam()
    local speed, direction = math.random(28, 40), lume.randomchoice({'north', 'east', 'south', 'west'}) 
    local vx, vy = 0, 0

    if     direction == "north" then vy = -1*speed
    elseif direction == "east" then vx = speed
    elseif direction == "south" then vy = speed
    elseif direction == "west" then vx = -1*speed
    end

    self:setLinearVelocity(vx, vy)
    self:setSequence("walk-"..direction)
    self:play()
  end

  function mob:timer()
    -- must be standing and physics active 
    if self.player:isStanding() and self.isBodyActive then
      if math.random() > 0.65 then self:roam()
      else self:wait()
      end
    end
  end

  function mob:moveTo(target, options) 
    local distance = lume.distance(self.x, self.y, target.x, target.y)
    options.time = distance*MOVEMENT_DELAY 
    options.x = target.x 
    options.y = target.y
    options.onCancel = self.moveToLastPosition
    options.onStart = function()
      if self.player:isLocationContested() then self:saveLastPosition() end
      self:updateDirection(target.x, target.y)
      self:pauseMotion()
    end

    self.transition_ID = transition.moveTo(self, options)
  end

  function mob:moveToLastPosition()
    if not self:hasLastPosition() then 
      self:resumeMotion()
      self:resetLastPosition()
      return 
    end

    local distance = lume.distance(self.x, self.y, self.last_x, self.last_y)
    options = {
      time = distance*MOVEMENT_DELAY,
      x = self.last_x,
      y = self.last_y,
      onComplete=function()
        self:resumeMotion()
        self:resetLastPosition()
      end,
    }
    self:updateDirection(self.last_x, self.last_y)
    self.transition_ID = transition.moveTo(self, options)
  end

  function mob:saveLastPosition() self.last_x, self.last_y = self.x, self.y end

  function mob:resetLastPosition() self.last_x, self.last_y = nil, nil end

  function mob:hasLastPosition() 
    return (self.last_x or self.last_y) and true or false 
  end

  function mob:isTouch(action) return self.current_action == action end

  function mob:setTouch(action) self.current_action = action end

  function mob:cancelAction() self.current_action = nil end

  function mob:cancelTimers()
    if self.action_timer then timer.cancel(self.action_timer) end
    if self.transition_ID then transition.cancel(self.transition_ID) end
    self.transition_ID = nil
    self.action_timer = nil
  end

	return mob
end

return Plugin