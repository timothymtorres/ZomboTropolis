local lume = require('code.libs.lume')

local MOVEMENT_DELAY = 7

local function Plugin(mob)	
--[[
  mob[1] & mob[2] are the name/name_background

  mob.movement_timer     -- used to roam around map under a recurring timer
  mob.action_timer       -- used to repeat actions (tap&hold)
  mob.transition_ID      -- used to track transitions involving mob
  mob.current_action     -- string value of the current action
  mob.last_x, mob.last_y -- saves last position before action taken
--]]

  function mob:setAnimation(animation)
    for i=3, self.numChildren do self[i]:setSequence(animation) end
  end

  function mob:playAnimation()
    for i=3, self.numChildren do self[i]:play() end
  end

  function mob:pauseAnimation()
    for i=3, self.numChildren do
       self[i]:pause() 
       self[i]:setFrame(1)
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

    self:setAnimation("walk-"..dir)  -- changes direction 
  end

  function mob:stopPhysics()
    self:setLinearVelocity(0, 0) 
    self.isBodyActive = false
  end

  function mob:resumePhysics() self.isBodyActive = true end

  function mob:wait() 
    self:setLinearVelocity(0, 0) 
    self:pauseAnimation()
  end

  function mob:roam()
    local speed, direction = math.random(28, 40), lume.randomchoice({'north', 'east', 'south', 'west'}) 
    local vx, vy = 0, 0

    if     direction == "north" then vy = -1*speed
    elseif direction == "east" then vx = speed
    elseif direction == "south" then vy = speed
    elseif direction == "west" then vx = -1*speed
    end

    self:setLinearVelocity(vx, vy)
    self:setAnimation("walk-"..direction)
    self:playAnimation()
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
      self:stopPhysics()
      self:playAnimation()
    end

    -- adds a wrapper function self:pauseAnimation() to options.onComplete 
    local onComplete = options.onComplete
    options.onComplete = function()
      self:pauseAnimation() 
      self.transition_ID = nil
      if onComplete then onComplete() end
    end

    self.transition_ID = transition.moveTo(self, options)
  end

  function mob:moveToLastPosition()
    if not self:hasLastPosition() then 
      self:resumePhysics()
      return 
    end

    local distance = lume.distance(self.x, self.y, self.last_x, self.last_y)
    options = {
      time = distance*MOVEMENT_DELAY,
      x = self.last_x,
      y = self.last_y,
      onComplete=function()
        self:pauseAnimation()
        self:resumePhysics()
        self:resetLastPosition()
        self.transition_ID = nil
      end,
    }
    self:updateDirection(self.last_x, self.last_y)
    self:playAnimation()
    self.transition_ID = transition.moveTo(self, options)
  end

  function mob:saveLastPosition() self.last_x, self.last_y = self.x, self.y end

  function mob:resetLastPosition() self.last_x, self.last_y = nil, nil end

  function mob:hasLastPosition() 
    return (self.last_x or self.last_y) and true or false 
  end

  function mob:isTouch(action) return self.current_action == action end

  function mob:setTouch(action) self.current_action = action end

  function mob:cancelAction()
    self.current_action = nil

    if self.action_timer then timer.cancel(self.action_timer) end
    if self.transition_ID then transition.cancel(self.transition_ID) end
    self.transition_ID = nil
    self.action_timer = nil
  end

	return mob
end

return Plugin