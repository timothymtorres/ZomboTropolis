
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end

	local transmitter = object:getVisual() 

	function transmitter:install()
		self:setSequence('transmitter-off')
		object:show()		
	end

	function transmitter:destroy()
		self:setSequence('transmitter-off')
		object:hide()
	end

	function transmitter:setPower(setting)
		self:setSequence('transmitter-'..setting)
		self:play()
	end

	return transmitter
end

return M
