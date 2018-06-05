
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local visual = object:getVisual()

	-- to change sprite to other mobs/races	
	--visual:setSequence('husk')  

	-- gets our name/bkgr stuff and attaches it to mob sprite
	local room = object.map
	local name_layer = room:getObjectLayer('Mob Name')
	local name_bkgr_layer = room:getObjectLayer('Mob Name Background')

	local name_obj = name_layer:getObject(object.name)
	local name_bkgr_obj = name_bkgr_layer:getObject(object.name)

	local name_visual = name_obj:getVisual()
	local name_bkgr_visual = name_bkgr_obj:getVisual()

	visual.name_sprites = {name_visual, name_bkgr_visual}

	local room_sprite = room:getVisual()
	local room_width, room_height = room_sprite.contentWidth, room_sprite.contentHeight

	function visual:travel(dir)
		visual:setFrame(dir)  -- changes direction		

		local new_x, new_y = 0, 0
		local distance = math.random(20, 40)
		local time_delay = math.random(10, 20) * 100

		if dir == 1 then new_y = -1*distance
		elseif dir == 2 then new_x = distance
		elseif dir == 3 then new_y = distance
		elseif dir == 4 then new_x = -1*distance
		end

		local x_movement = (new_x == 0 or visual.x + new_x > room_width - 48 or visual.x + new_x < 48) and 0 or new_x
		local y_movement = (new_y == 0 or visual.y + new_y > room_height - 48 or visual.y + new_y < 48) and 0 or new_y

		transition.to( visual, { time=time_delay, x=visual.x + x_movement, y=visual.y + y_movement, iterations = 1} )

		for _, name_visual in ipairs(visual.name_sprites) do
			transition.to( name_visual, { time=time_delay, x=name_visual.x + x_movement, y=name_visual.y + y_movement, iterations = 1} )
		end
	end

	return visual
end

return M
