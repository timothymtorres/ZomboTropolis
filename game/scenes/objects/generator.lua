function Plugin(generator)	
	if not generator then error( "ERROR: Expected display visual" ) end

	function generator:install()
		self:setSequence('generator-off')
		self.alpha = 1
	end

	function generator:destroy()
		self:setSequence('generator-off')
		self.alpha = 0
	end

	function generator:setPower(setting)
		self:setSequence('generator-'..setting)
		self:play()
	end

	return generator
end

return Plugin