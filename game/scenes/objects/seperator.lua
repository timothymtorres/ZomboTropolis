function Plugin(seperator)	
	function seperator:toggle(setting) 
		self.isBodyActive = setting 
	end

	return seperator
end

return Plugin