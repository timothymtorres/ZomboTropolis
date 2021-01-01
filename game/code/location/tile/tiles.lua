local csv_helpers = require('code.libs.csv_helpers')
local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')
local Building = require('code.location.tile.building.building')

local Tiles = {}

-- import class data into location class
local location_path = system.pathForFile("spreadsheet/data/location - tiles.csv", system.ResourceDirectory)
local locations = csv_helpers.convertToLua(location_path)

for i, location in ipairs(locations) do
  local is_building = location.BUILDING_TYPE
  local Location = class(location.NAME, is_building and Building or Tile)

  -- copy our data to our location class
  for k, v in pairs(location) do Location[k] = v end

  Tiles[i] = Location
  Tiles[location.NAME] = Location
end

-- import item drops and search odds into location
local location_items_path = system.pathForFile("spreadsheet/data/location - items.csv", system.ResourceDirectory)
local location_items = csv_helpers.convertItemDrops(location_items_path)

for location, items in pairs(location_items) do
  Tiles[location].search_odds = items.search_odds
  Tiles[location].item_chance = items.item_chance
end

return Tiles
