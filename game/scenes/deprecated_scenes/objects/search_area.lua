
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )
local item_effect = require('scenes.objects.item_effect')

local MAX_MOVEMENT_DELAY = 20 * 100
local MIN_MOVEMENT_DELAY = 10 * 100
local ANIMATION_DELAY = 1000
local FIRST_SEARCH_DELAY = 1500
local SEARCH_DELAY = ANIMATION_DELAY

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local search_area = object:getVisual() 
	search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register

	-- the variable locations for our timer IDs
	search_area.search_timer = nil
	search_area.unfreeze_timer = nil 

	local function getMobSprite(player)
		local location = object.map
		local mob_layer = location:getObjectLayer('Mob')
		local mob_obj = mob_layer:getObject(player:getUsername())
		return mob_obj:getVisual()
	end

	local function unfreezeMobSprite()
		local mob_sprite = getMobSprite(main_player)
	    mob_sprite:setStationary(false)
		search_area.unfreeze_timer = nil
	end

	function search_area.search(event)
		if main_player:canPerform('search') then
			local mob_sprite = getMobSprite(main_player)
			local movement_delay = math.random(MIN_MOVEMENT_DELAY, MAX_MOVEMENT_DELAY)
			mob_sprite:move(search_area.x, search_area.y, movement_delay)

			local result = main_player:perform('search')
			local item = result[3]

			if result[3] then
print('WE FOUND '..tostring(result[3]))
				local scale = 0.30

				if mob_sprite:isStationary() then movement_delay = 0 end

				timer.performWithDelay(movement_delay, function()
					local item_obj = item_effect.new(object.map, item, search_area.x, search_area.y)				
					transition.to( item_obj:getVisual(), { time=ANIMATION_DELAY, transition=easing.inExpo, x=mob_sprite.x, y=mob_sprite.y, xScale=scale, yScale=scale} )
					transition.to( item_obj.bkgr:getVisual(), { time=ANIMATION_DELAY, transition=easing.inExpo, x=mob_sprite.x, y=mob_sprite.y, xScale=scale, yScale=scale} )

					timer.performWithDelay(ANIMATION_DELAY, function()
						item_obj.bkgr:destroy()
						item_obj:destroy()	
					end)
				end)			

			else
print('NOTHING FOUND')
			end
			mob_sprite:setStationary(true)
		else
			-- make error sound
		end	
	end

	function search_area.timer(event) search_area.search(event) end

	function search_area.touch(event)
		local mob_sprite = getMobSprite(main_player)
		local time_delay

	    if ( event.phase == "began" ) then
	        display.getCurrentStage():setFocus( event.target )  --'event.target' is the touched object
print('touch event has began')

	        if not search_area.search_timer then
print('search_area.search_timer is about to be set')

				-- we need a way to continously search but before we do that
				-- we need to check if the player has moved to the search area
				-- beforehand?  I'm stumped... gah.




	        	search_area.search_timer = timer.performWithDelay(SEARCH_DELAY, search_area, 0)
	        else
	        	-- should we return true here?  maybe this avoids other event.phase from being triggered?
	        end
	    elseif (event.phase == "moved") then
print('canceling search timer')
	    	timer.cancel(search_area.search_timer)

	    	if not search_area.unfreeze_timer then
	    		local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
	    		search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
	    	end
	    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
	        display.getCurrentStage():setFocus( nil )  --setting focus to 'nil' removes the focus
	        timer.cancel(search_area.search_timer)
	        search_area.search_timer = nil

	        if not search_area.unfreeze_timer then
	        	local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
	    		search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
	    	end
	    end
		return true
	end

	function search_area.tap(event)
		local mob_sprite = getMobSprite(main_player)
	    if ( event.numTaps == 2 ) then 
	    	search_area.search(event) 

	    	if not search_area.unfreeze_timer then
		    	local time_delay = (mob_sprite:isStationary() and 0 or MAX_MOVEMENT_DELAY) + ANIMATION_DELAY
		    	search_area.unfreeze_timer = timer.performWithDelay(time_delay, unfreezeMobSprite)
		    end
	    end
	end

	local player_stage = main_player:getStage()
	local search_area_is_same_stage_as_player = object.name == player_stage

	if search_area_is_same_stage_as_player and main_player:isMobType('human') then
		search_area:addEventListener("touch", search_area.touch)
		search_area:addEventListener("tap", search_area.tap)		
	end

	return search_area
end

return M
