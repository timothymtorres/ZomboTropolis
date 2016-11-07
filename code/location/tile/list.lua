local tile = {}

--[[
  full_name = 'insert name'
  resources = 0, 1, 2, 3
  item_chance = {outside = {item = 0.00}, inside = {item = 0.00}}
  barricade = {size = 'desc'}
--]]

tile.street =  {}
tile.street.full_name = 'street'
tile.street.item_chance =  {}
tile.street.item_chance.outside = {
  -- WEAPONS =  00.1%
  knife = .001,

  -- MISC   =  09.9%
  newspaper = .099,

  -- EQUIPMENT =  90%
  barricade = .90,
}

--[[  barricade descriptions inserted at a later time
tile.street.barricades = {
  small = {'cinder blocks'},
  medium = {'pieces of scrap metal',},
  large = {'trash can',},
  heavy = {'tire',},
}
--]]

tile.cemetary = {}
tile.cemetary.full_name = 'cemetary'
tile.cemetary.item_chance = {}

tile.monument = {}
tile.monument.full_name = 'monument'
tile.monument.item_chance = {}
tile.monument.barricades = {}

tile.park = {}
tile.park.full_name = 'park'
tile.park.item_chance = {}
tile.park.barricades = {}

tile.wasteland = {}
tile.wasteland.full_name = 'wasteland'
tile.wasteland.item_chance = {}
tile.wasteland.barricades = {}

tile.stadium = {}
tile.stadium.full_name = 'stadium'
tile.stadium.item_chance = {}
tile.stadium.barricade = {}

tile.junkyard = {}
tile.junkyard.full_name = 'junkyard'
tile.junkyard.item_chance = {}
tile.junkyard.barricade = {}

tile.carpark = {}
tile.carpark.full_name = 'carpark'
tile.carpark.item_chance = {}
tile.carpark.barricade = {}

return tile