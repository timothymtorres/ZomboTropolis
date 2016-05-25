local building = require('code.location.building.class')
local tile = require('code.location.tile.class')

local area_list = {
  -- TILES
  tile.street, tile.cemetary, tile.monument, tile.park, tile.wasteland, 
  tile.stadium, tile.junkyard, tile.carpark, 
  -- BUILDINGS
  building.PD, building.FD, building.warehouse, building.factory, building.sport, 
  building.hotel, building.hospital, building.apartment, building.warehouse, building.factory, 
  building.school, building.library, building.mall, building.bar, building.bank, 
  building.museum, building.power, building.lab, building.ISP, building.toolshop, 
  building.theatre, building.church, building.nightclub, building.gas, building.vacant,
  building.power, building.food, 
}

for ID, area in ipairs(area_list) do 
--print(area:getName(), ID)
--print(area) 
--for k,v in pairs(area) do print(k,v) end
--print()
  area_list[area:getName()] = ID 
  area.ID = ID
end

local function lookup(area)
--print(area)  
  if type(area) == 'string' then 
    local ID = area_list[area]
    area = area_list[ID]
  elseif type(area) == 'number' then
    local ID = area
    area = area_list[ID]
  else
    error('area lookup invalid')
  end
  return area
end

return lookup