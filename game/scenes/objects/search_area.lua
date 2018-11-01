
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local search_area = object:getVisual() 

	-- create a tappable object here and handle game event

	return search_area
end

return M
