local Street, Cemetary, Wasteland = unpack(require('code.location.tile.tiles.barren')) 
local Carpark, Junkyard = unpack(require('code.location.tile.tiles.scrap'))
local Monument, Park, Stadium = unpack(require('code.location.tile.tiles.tourist'))
local Apartment, Hotel = unpack(require('code.location.tile.building.buildings.residential'))
local Library, School, College = unpack(require('code.location.tile.building.buildings.public'))
local Warehouse, Factory = unpack(require('code.location.tile.building.buildings.industrial'))
local PD, FD, Hospital, Courthouse = unpack(require('code.location.tile.building.buildings.government'))
local News, Sport, Bar, Mall = unpack(require('code.location.tile.building.buildings.commercial'))

local Tile = {
---- OUTSIDE ----

  -- BARREN
  Street, Cemetary, Wasteland,
  -- SCRAP 
  Carpark, Junkyard,
  -- TOURIST
  Monument, Park, Stadium,

---- INSIDE ----

  -- RESIDENTIAL
  Apartment, Hotel,
  -- PUBLIC
  Library, School, College,
  -- INDUSTRIAL
  Warehouse, Factory,
  -- GOVERNMENT
  PD, FD, Hospital, Courthouse,
  -- COMMERCIAL
  News, Sport, Bar, Mall,
}

for _, Class in ipairs(Tile) do 
  Tile[Class.name] = Class 
end

return Tile