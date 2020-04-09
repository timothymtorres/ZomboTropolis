local csv = require('code.libs.csv')
local lume = require('code.libs.lume')
local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')
local Building = require('code.location.tile.building.building')

local Tiles = {}

-- this will take a header like "Full Name" and convert it into "FULL_NAME"
local function headerToConstant(header)
  header = string.gsub(header, '%s+', '_')  -- replace all spaces with _
  return string.upper(header) -- all caps
end

local location_path = system.pathForFile("code/location/locations.csv", system.ResourceDirectory) 
local locations, constants = csv.parse(location_path, {headerFunc=headerToConstant} )

-- import locations
for location_i, location_data in ipairs(locations) do
  local location_name 

  -- need to properly cleanup the data
  for constant, data in pairs(location_data) do
    if data == "" then -- remove empty data
      location_data[constant] = nil
    elseif data == "TRUE" then 
      location_data[constant] = true
    elseif data == "FALSE" then 
      location_data[constant] = false
    elseif type(tonumber(data)) == 'number' then
      location_data[constant] = tonumber(data) 
    elseif constant == "ALTERNATE_NAME" then -- split string into array with names
      location_data.ALTERNATE_NAME = lume.split(data, "/")
    elseif constant == "LOCATION" then
      location_name = data -- save location name to variable 
      location_data.LOCATION = nil -- and remove it from out data table
    end
  end

  local is_building = location_data.BUILDING_TYPE
  local Location = class(location_name, is_building and Building or Tile)

  -- copy our data to our location class
  for constant, data in pairs(location_data) do Location[constant] = data end

  -- setup tables for search_odds & items
  Location.search_odds = {}
  Location.item_chance = {}

  Tiles[location_i] = Location
  Tiles[Location.name] = Location 
end

local outside_items_path = system.pathForFile("code/location/tile/outside-items.csv", system.ResourceDirectory) 
local outside_items = csv.parse(outside_items_path, {headers=false})
local total_tiles = #outside_items[2]

-- import outside items
for tile_i=2, total_tiles do
  local chance = outside_items[1][tile_i] 
  chance = string.match(chance, '%d+') -- remove the % from the string
  chance = tonumber(chance) * 0.01 -- convert str to num and move the decimal to correct position 

  local tile = outside_items[2][tile_i]

  Tiles[tile].search_odds.outside = chance
  Tiles[tile].item_chance.outside = {}

  for item_i=3, #outside_items do
    local item = string.gsub(outside_items[item_i][1], '%s+', '_') -- replace spaces in strings with _
    local item_weight = tonumber(outside_items[item_i][tile_i])
    Tiles[tile].item_chance.outside[item] = item_weight
  end
end

local inside_items_path = system.pathForFile("code/location/tile/building/inside-items.csv", system.ResourceDirectory) 
local inside_items = csv.parse(inside_items_path, {headers=false})
local total_buildings = #inside_items[2]

-- import inside items
for building_i=2, total_buildings do
  local chance = inside_items[1][building_i] 
  chance = string.match(chance, '%d+') -- remove the % from the string
  chance = tonumber(chance) * 0.01 -- convert str to num and move the decimal to correct position 

  local building = inside_items[2][building_i]
  Tiles[building].search_odds.inside = chance

  Tiles[building].item_chance.inside = {}
  for item_i=3, #inside_items do
    local item = string.gsub(inside_items[item_i][1], '%s+', '_') -- replace spaces in strings with _
    local item_weight = tonumber(inside_items[item_i][building_i])
    Tiles[building].item_chance.inside[item] = item_weight
  end
end

return Tiles