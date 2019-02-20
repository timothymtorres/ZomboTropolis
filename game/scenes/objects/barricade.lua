local function Plugin(barricade)	
	if not barricade then error( "ERROR: Expected display visual" ) end 

	function barricade:setAlpha(visible) self.alpha = (visible and 1) or 0  end

	function barricade:setHealth(hp_state) self:setFrame(hp_state) end

	return barricade
end

return Plugin