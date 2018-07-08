local Land, Street, Cemetary, Wasteland, Runway, Forest, Obstical= unpack(require('code.location.tile.tiles.barren')) 
local Carpark, Junkyard = unpack(require('code.location.tile.tiles.scrap'))
local Monument, Park, Stadium = unpack(require('code.location.tile.tiles.tourist'))
local Apartment = unpack(require('code.location.tile.building.buildings.residential'))
local Library, News, Museum, Church = unpack(require('code.location.tile.building.buildings.public'))
local Warehouse, Factory, Power, Control = unpack(require('code.location.tile.building.buildings.industrial'))
local PD, FD, Hospital, Lab = unpack(require('code.location.tile.building.buildings.government'))
local Gas, Shop, Mall = unpack(require('code.location.tile.building.buildings.commercial'))
local Bar, Sport = unpack(require('code.location.tile.buillding.buildings.entertainment'))
local Gatehouse, Infirmary, Armory, Supply, Barracks = unpack(require('code.location.tile.building.buildings.military'))

local Tile = {
  Land, Street, Cemetary, Wasteland,  
  Runway, Forest, Carpark, Junkyard, 
  Monument, Park, Stadium, Apartment,
  Library, News, Warehouse, Factory, 
  PD, FD, Hospital, Lab,
  Power, Control, Sport, Bar,
  Church, Museum, Gas, Shop, 
  Mall, Gatehouse, Infirmary, Armory,
  Supply, Barracks, Obstical

  --[[
  do only 1 type (and then when they purchase naming rights have a list of subtypes names)
  ie.  bar, pub, saloon, etc.

  museum, pawn, 
  power, lab, clinic, pharmacy,
  restaurant, church, gym, shop,
  control, gas, fort, field, 

  bar, museum, church, shop, -- smaller resource buildings... blue and light blue?
  sport, gas, pawn,

  bar, church, sport, gas,
  museum, pawn


  power, control tower, ? yes (resource building relevant to a region)
  gatehouse, infirmary/medbay, armory, supply, barracks, 

  --]]
}

for _, Class in ipairs(Tile) do 
  Tile[Class.name] = Class 
end

return Tile