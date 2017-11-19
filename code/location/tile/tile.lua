local Street, Cemetary, Monument, Park, Wasteland, Stadium, Junkyard, Carpark = unpack(require('code.location.tile.outside_areas'))

local Tile = {
  -- OUTSIDE AREAS
  Street, Cemetary, Monument, Park, Wasteland, Stadium, Junkyard, Carpark,
  -- RESIDENTIAL
  
}

for _, Class in ipairs(Tile) do 
  Tile[Tile.name] = Class 
end

return Tile