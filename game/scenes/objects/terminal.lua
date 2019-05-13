function Plugin(terminal)	
	if not terminal then error( "ERROR: Expected display visual" ) end
	terminal.isVisible = false -- Is invisible by default unless installed

	function terminal:install()
		self:setSequence('terminal-off')
		self.isVisible = true		
	end

	function terminal:destroy()
		self:setSequence('terminal-off')
		self.isVisible = false
	end

	function terminal:setPower(setting)
		self:setSequence('terminal-'..setting)
		self:play()
	end

	return terminal
end

return Plugin