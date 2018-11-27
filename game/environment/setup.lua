local setup = function(...)
	for _, environment in ipairs({...}) do
		require('environment.'..environment)
	end
end

return setup