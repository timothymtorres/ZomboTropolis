local activate = {}

function activate.transmitter(player, operation, ...) 
  local building = player:getTile()  
  building.transmitter[operation](building.transmitter, player, unpack({...}))
end

--[[
function activate.generator(player) end

function activate.terminal(player, operation) end
--]]

return activate