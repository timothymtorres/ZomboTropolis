function Plugin(transmitter)	
	if not transmitter then error( "ERROR: Expected display visual" ) end

	function transmitter:install()
		self:setSequence('transmitter-off')
		self.alpha = 1		
	end

	function transmitter:destroy()
		self:setSequence('transmitter-off')
		self.alpha = 0
	end

	function transmitter:setPower(setting)
		self:setSequence('transmitter-'..setting)
		self:play()
	end

	return transmitter
end

return Plugin