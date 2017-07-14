local check = {}

--[[
--- MEDICAL
--]]

function check.FAK(player) end -- limit FAK's so they cannot be used on self (only others)

function check.bandage(player) end

function check.antibodies(player) end

function check.antidote(player) end

function check.syringe(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby')  
end

--[[
--- WEAPONS
--]]

function check.flare(player)
  assert(player:isStaged('outside'), 'Player must be outside to use flare')  
end

--[[
--- GADGETS
--]]

function check.radio(player) end --needs batteries/need light

function check.cellphone(player) end -- check if phone towers functional/need light/need battery

function check.sampler(player)
  local p_tile, setting = player:getTile(), player:getStage()
  local zombie_n = p_tile:countPlayers('zombie', setting) 
  assert(zombie_n > 0, 'No zombies are nearby') 
end

function check.GPS(player) end -- need light/need battery

--+-- ***  LOCAL FUNCTION  *** --+--
local function playerInsideBuilding(player)
  local p_tile = player:getTile()
  return p_tile:isBuilding() and player:isStaged('inside')   
end
--+-- ***  LOCAL FUNCTION  *** --+--

--[[
--- EQUIPMENT
--]]

function check.barricade(player)
  local p_tile = player:getTile()
  assert(playerInsideBuilding(player), 'Must be inside building to barricade')
  assert(p_tile.barricade:roomForFortification(), 'There is no room available for fortifications')
  assert(p_tile.barricade:canPlayerFortify(player), 'Unable to make stronger fortification without required skills')  
end

function check.fuel(player)
  local p_tile = player:getTile()
  assert(playerInsideBuilding(player), 'Must be inside building to refuel')
  assert(p_tile.generator:isPresent(), 'Missing nearby generator to refuel')
end

function check.generator(player)
  local p_tile = player:getTile()
  assert(playerInsideBuilding(player), 'Must be inside building to install generator')
  assert(not p_tile.generator:isPresent(), 'There is no room for a second generator') 
end

function check.transmitter(player)
  local p_tile = player:getTile()  
  assert(playerInsideBuilding(player), 'Must be inside building to install transmitter')
  assert(not p_tile.transmitter:isPresent(), 'There is no room for a second transmitter')
end

function check.terminal(player)
  local p_tile = player:getTile()
  assert(playerInsideBuilding(player), 'Must be inside building to install terminal')
  assert(not p_tile.terminal:isPresent(), 'There is no room for a second terminal')
end


--[[
--- JUNK
--]]

function check.book(player) end  -- need light?

function check.newspaper(player) end  -- need light?

function check.bottle(player) end

--[[
--- BARRICADES
--]]

function check.barricade(player) 
  assert(playerInsideBuilding(player), 'Must be inside building to use barricade')    
end

return check    