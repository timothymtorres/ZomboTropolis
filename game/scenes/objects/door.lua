function Plugin(door)	
	if not door then error( "ERROR: Expected display visual" ) end

	function door:setAlpha(visible) self.alpha = (visible and 1) or 0 end

	return door
end

return Plugin