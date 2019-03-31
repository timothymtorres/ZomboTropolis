function Plugin(terminal)	
	if not terminal then error( "ERROR: Expected display visual" ) end
	terminal.alpha = 0 -- Is invisible by default unless installed

	function terminal:install()
		self:setSequence('terminal-off')
		self.alpha = 1		
	end

	function terminal:destroy()
		self:setSequence('terminal-off')
		self.alpha = 0
	end

	function terminal:setPower(setting)
		self:setSequence('terminal-'..setting)
		self:play()
	end

	return terminal
end

return Plugin