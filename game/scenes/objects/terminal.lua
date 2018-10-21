
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local terminal = object:getVisual() 

	function terminal:install()
		self:setSequence('terminal-off')
		object:show()		
	end

	function terminal:destroy()
		self:setSequence('terminal-off')
		object:hide()
	end

	function terminal:setPower(setting)
		self:setSequence('terminal-'..setting)
		self:play()
	end

	return terminal
end

return M
