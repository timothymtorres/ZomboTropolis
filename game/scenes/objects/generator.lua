function Plugin(generator)	
	if not generator then error( "ERROR: Expected display visual" ) end
	generator.isVisible = false -- Is invisible by default unless installed

	function generator:install()
		self:setSequence('generator-off')
		self.isVisible = true
	end

	function generator:destroy()
		self:setSequence('generator-off')
		self.isVisible = false
	end

	function generator:setPower(setting)
		self:setSequence('generator-'..setting)
		self:play()
	end

	return generator
end

return Plugin