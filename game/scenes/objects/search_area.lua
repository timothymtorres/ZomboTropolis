
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )
local searchTimer

local function searchTrigger(event)
	print(table.inspect(searchTimer))
	print('YOU HAVE SEARCHED')
end

local function touchListener(event)
    if ( event.phase == "began" ) then
        display.getCurrentStage():setFocus( event.target )  --'event.target' is the touched object
        searchTimer = timer.performWithDelay(300, searchTrigger, 0)
        return true
    elseif (event.phase == "moved") then
    	timer.cancel(searchTimer)
    	return true
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        display.getCurrentStage():setFocus( nil )  --setting focus to 'nil' removes the focus
        timer.cancel(searchTimer)
        return true
    end
	return true
end

local function tapListener(event)
    if ( event.numTaps == 2 ) then
    	searchTrigger(event)
    end
end

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local search_area = object:getVisual() 
	search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register

	local player_stage = main_player:getStage()
	local search_area_is_same_stage_as_player = object.name == player_stage

	if search_area_is_same_stage_as_player and main_player:isMobType('human') then
		search_area:addEventListener("touch", touchListener)
		search_area:addEventListener("tap", tapListener)		
	end

	return search_area
end

return M
