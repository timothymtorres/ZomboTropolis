local function Plugin(mob)	
	if not mob then error( "ERROR: Expected display visual" ) end

  mob:pause()
  mob:setFrame(math.random(4))

  if mob.player:isStanding() then
    -- only apply physics to standing mobs
  	local physics_properties = {bounce = 1, filter={groupIndex = -1}}
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

        self:setFrame(direction) 
      end
    end

    mob:addEventListener( "collision", mob )
  elseif not mob.player:isStanding() then 
    mob:setFillColor(1, 0, 0) -- remove this when we add actual graphics
  end

  function mob:move()
    if not mob.player:isStanding() then return end

    local speed, direction = 32, math.random(4)

    if direction == 1 then mob:setLinearVelocity(0, -1*speed)
    elseif direction == 2 then mob:setLinearVelocity(speed, 0)
    elseif direction == 3 then mob:setLinearVelocity(0, speed)
    elseif direction == 4 then mob:setLinearVelocity(-1*speed, 0)
    end

    mob:setFrame(direction)
  end

	return mob
end

return Plugin