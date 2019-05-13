local function Plugin(apc)	
	if not apc then error( "ERROR: Expected display visual" ) end
	apc.isVisible = true

	function apc:setPower(setting)
		self:setSequence('apc-'..setting)
		self:play()
	end

	return apc
end

return Plugin