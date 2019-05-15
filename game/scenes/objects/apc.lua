local function Plugin(apc)	
	apc.isVisible = true

	function apc:setPower(setting)
		self:setSequence('apc-'..setting)
		self:play()
	end

	return apc
end

return Plugin