
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local barricade = object:getVisual() 

	function barricade:setVisual(setting) 
		if setting == true then object:show() else object:hide() end 
	end

	function barricade:setSprite(hp_state)
		barricade:setFrame(hp_state)
		self:setFrame(hp_state)
	end

	-- maybe have a destroy method?  idk

	return barricade
end

return M
