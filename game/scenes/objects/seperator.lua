function Plugin(seperator)	
	if not seperator then error( "ERROR: Expected display visual" ) end

	function seperator:toggle(setting) 
		self.isBodyActive = setting 
	end

	return seperator
end

return Plugin