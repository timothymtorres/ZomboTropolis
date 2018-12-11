
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local mob = object:getVisual()

	-- to change sprite to other mobs/races	
	--mob:setSequence('husk')  

	-- gets our name/bkgr stuff and attaches it to mob sprite
	local location = object.map
	local name_layer = location:getObjectLayer('Mob Name')
	local name_bkgr_layer = location:getObjectLayer('Mob Name Background')

	local name_obj = name_layer:getObject(object.name)
	local name_bkgr_obj = name_bkgr_layer:getObject(object.name)

	local name = name_obj:getVisual()
	local name_bkgr = name_bkgr_obj:getVisual()

	mob.name_sprites = {name, name_bkgr}

	local location_sprite = location:getVisual()
	local location_width, location_height = location_sprite.contentWidth, location_sprite.contentHeight

  	-- gets the section of location the player is staged in
	local player_stage = main_player:getStage()
	stage_layer = location:getTileLayer(player_stage)

	-- sets the boundry for the section of the location
	local stage_boundry_x_left, stage_boundry_x_right = stage_layer:getPropertyValue('boundry_left'), stage_layer:getPropertyValue('boundry_right')
	local stage_boundry_y_top, stage_boundry_y_bottom = stage_layer:getPropertyValue('boundry_top'), stage_layer:getPropertyValue('boundry_bottom')

	function mob:travel(dir)
		mob:setFrame(dir)  -- changes direction		

		local new_x, new_y = 0, 0
		local distance = math.random(20, 40)
		local time_delay = math.random(10, 20) * 100

		if dir == 1 then new_y = -1*distance
		elseif dir == 2 then new_x = distance
		elseif dir == 3 then new_y = distance
		elseif dir == 4 then new_x = -1*distance
		end

		local wall_offset = 4

		local x_movement = (new_x == 0 or mob.x + new_x > stage_boundry_x_right - wall_offset or mob.x + new_x < stage_boundry_x_left + wall_offset) and 0 or new_x
		local y_movement = (new_y == 0 or mob.y + new_y > stage_boundry_y_bottom - wall_offset or mob.y + new_y < stage_boundry_y_top + wall_offset) and 0 or new_y

		transition.to( mob, { time=time_delay, x=mob.x + x_movement, y=mob.y + y_movement, iterations = 1} )

		for _, name in ipairs(mob.name_sprites) do
			transition.to( name, { time=time_delay, x=name.x + x_movement, y=name.y + y_movement, iterations = 1} )
		end
	end

	function mob:move(x, y, time_delay)	
		local new_x, new_y = x - mob.x, y - mob.y

		local wall_offset = 4

		local x_movement = (new_x == 0 or mob.x + new_x > stage_boundry_x_right - wall_offset or mob.x + new_x < stage_boundry_x_left + wall_offset) and 0 or new_x
		local y_movement = (new_y == 0 or mob.y + new_y > stage_boundry_y_bottom - wall_offset or mob.y + new_y < stage_boundry_y_top + wall_offset) and 0 or new_y

		local dir 
		if math.abs(x_movement) >= math.abs(y_movement) then
			if x_movement >= 0 then dir = 2 -- face east
			elseif x_movement < 0 then dir = 4 -- face west
			end
		elseif math.abs(x_movement) < math.abs(y_movement) then
			if y_movement >= 0 then dir = 3 -- face south
			elseif y_movement < 0 then dir = 1 -- face north
			end
		end

		mob:setFrame(dir)  -- changes direction	

		transition.to( mob, { time=time_delay, x=mob.x + x_movement, y=mob.y + y_movement, iterations = 1} )

		for _, name in ipairs(mob.name_sprites) do
			transition.to( name, { time=time_delay, x=name.x + x_movement, y=name.y + y_movement, iterations = 1} )
		end
	end

	return mob
end

return M
