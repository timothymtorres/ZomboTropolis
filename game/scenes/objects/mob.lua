local function Plugin(mob)	
	if not mob then error( "ERROR: Expected display visual" ) end

    mob:pause()
    mob:setFrame(math.random(4))
    local physics_properties = {bounce = 1}
    physics.addBody(mob, physics_properties )
 
	return mob
end

return Plugin