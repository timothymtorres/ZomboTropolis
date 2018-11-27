-- this sets up objects and events in the game for testing 
-- here you can load different things: 
-- a generator full of fuel, a hurt character, different items, performing actions with players, etc.
local setup = function(...)
	for _, environment in ipairs({...}) do
		require('environment.'..environment)
	end
end

return setup