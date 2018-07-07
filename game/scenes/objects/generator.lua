
-- Module/class for platfomer hero

-- Use this as a template to build an in-game mob

-- Define module
local M = {}
local composer = require( "composer" )

function M.new( object )	
	if not object then error( "ERROR: Expected display visual" ) end
	local generator = object:getVisual() 
	local room = object.map

	function generator:install()
		self:setSequence('generator-off')
		self:show()		
	end

	function generator:destroy()
		self:setSequence('generator-off')
		self:hide()
	end

	function generator:setPower(setting)
		self:setSequence('generator-'..setting)
		self:play()
		room:setPower(setting) -- I think this is right
	end

	return generator
end

return M
