local function Plugin(mob)	
	if not mob then error( "ERROR: Expected display visual" ) end

  mob:pause()
  mob:setFrame(math.random(4))

  -- remove this when we add actual graphics
  if not mob.player:isStanding() then 
    mob:setFillColor(1, 0, 0) 
  else -- only apply physics to standing mobs
  	local physics_properties = {bounce = 1, filter={groupIndex = -1}}
  	physics.addBody(mob, physics_properties )
    mob.isFixedRotation = true
  	mob:setLinearVelocity(32, 0)
  end

  function mob:timer()
    mob:setLinearVelocity(0, 0)
  end

  function mob:move()
    if not mob.player:isStanding() then return end

    local speed, direction = 32, math.random(4)

    if direction == 1 then mob:setLinearVelocity(0, -1*speed)
    elseif direction == 2 then mob:setLinearVelocity(speed, 0)
    elseif direction == 2 then mob:setLinearVelocity(0, speed)
    elseif direction == 2 then mob:setLinearVelocity(-1*speed, 0)
    end

    mob:setFrame(direction)
    timer.performWithDelay(1000, mob)
  end

	return mob
end

return Plugin