local lume = require('code.libs.lume')

local MOVEMENT_DELAY = 7

local function Plugin(mob)	
  -- mob is a snapshot
  -- mob.group[1] & mob.group[2] are the name/name_background

  function mob:setFrame(direction)
    self:invalidate()
    for i=3, self.group.numChildren do
      self.group[i]:setFrame(direction)
    end
  end

  -- create our name/background displays on top of mob
  local border = 3
  local standing_offset = is_player_standing and 28 or 22
  local font_size = 9

  local name_options = {
    text = mob.name,
    font = native.systemFont,
    fontSize = font_size,
    align = 'center',
    x = 0,
    y = 0 - standing_offset,
  }

  local name = display.newText(name_options)

  local x, y = name.x, name.y
  local w, h = name.contentWidth + border, font_size + border*2 
  local corner = h/4

  local name_background = display.newRoundedRect(x, y, w, h, corner)
  name_background:setFillColor(0.15, 0.15, 0.15, 0.65)

  mob.group:insert( 1, name_background )
  mob.group:insert( 2, name )

  mob:setFrame(math.random(4))

  if mob.player:isStanding() then
    local name = mob.player:getUsername()
    local font_size = 9

    -- only apply physics to standing mobs
    local mobFilter = { categoryBits=2, maskBits=1 } 
    local rectShape = { -16,-16, -16,16, 16,16, 16,-16  }
  	local physics_properties = {shape= rectShape, bounce = 1, filter=mobFilter}
  	physics.addBody(mob, physics_properties )
    mob.isFixedRotation = true

    mob.collision = function( self, event )
      if ( event.phase == "ended" ) then
        local vx, vy = self:getLinearVelocity()
        local direction 

        if vy < 0 then direction = 1
        elseif vx > 0 then direction = 2
        elseif vy > 0 then direction = 3
        elseif vx < 0 then direction = 4
        end

        if direction then
          self:setFrame(direction) 
        end
      end
    end

    mob:addEventListener( "collision", mob )

  elseif not mob.player:isStanding() then 
    --consider removing the mob name/background 
    mob:setFillColor(1, 0, 0) -- remove this when we add actual graphics
  end

  function mob:updateDirection(x, y) 
    local x_distance, y_distance = x - self.x, y - self.y
    local dir 

    if math.abs(x_distance) >= math.abs(y_distance) then
      if x_distance >= 0 then dir = 2 -- face east
      elseif x_distance < 0 then dir = 4 -- face west
      end
    elseif math.abs(x_distance) < math.abs(y_distance) then
      if y_distance >= 0 then dir = 3 -- face south
      elseif y_distance < 0 then dir = 1 -- face north
      end
    end

    mob:setFrame(dir)  -- changes direction 
  end

  function mob:pauseMotion()
    self:setLinearVelocity(0, 0) 
    self.isBodyActive = false
  end

  function mob:resumeMotion() self.isBodyActive = true end

  function mob:wait() self:setLinearVelocity(0, 0) end

  function mob:roam()
    local speed, direction = math.random(28, 40), math.random(4)
    local vx, vy = 0, 0

    if     direction == 1 then vy = -1*speed
    elseif direction == 2 then vx = speed
    elseif direction == 3 then vy = speed
    elseif direction == 4 then vx = -1*speed
    end

    self:setLinearVelocity(vx, vy)
    self:setFrame(direction) 
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

    return transition.moveTo(self, options)
  end

  function mob:moveToLastPosition()
    if not self:hasLastPosition() then return end

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
    return transition.moveTo(self, options)
  end

  function mob:saveLastPosition() self.last_x, self.last_y = self.x, self.y end

  function mob:resetLastPosition() self.last_x, self.last_y = nil, nil end

  function mob:hasLastPosition() 
    return (self.last_x or self.last_y) and true or false 
  end

  function mob:isActivity(action) return self.current_activity == action end

  function mob:setActivity(action) self.current_activity = action end

  function mob:resetActivity() self.current_activity = nil end

	return mob
end

return Plugin