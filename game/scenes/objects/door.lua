
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local door = object:getVisual() 


	--[[-- so technically this should be like barricade object, but right now we don't have a damage sprite for doors...

	function door:setSprite(hp_state)
		self:setFrame(hp_state)
	end

	--]]

	function door:setVisual(setting) 
		if setting == true then object:show() else object:hide() end 
	end

	return door
end

return M
