function Plugin(transmitter)	
	transmitter.isVisible = false -- Is invisible by default unless installed

	function transmitter:install()
		self:setSequence('transmitter-off')
		self.isVisible = true		
	end

	function transmitter:destroy()
		self:setSequence('transmitter-off')
		self.isVisible = false
	end

	function transmitter:setPower(setting)
		self:setSequence('transmitter-'..setting)
		self:play()
	end

	return transmitter
end

return Plugin