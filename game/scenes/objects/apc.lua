
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local apc = object:getVisual() 

	function apc:setPower(setting)
		self:setSequence('apc-'..setting)
		self:play()
	end

	return apc
end

return M
