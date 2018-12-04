local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local Gatehouse = class('Gatehouse', Building)

Gatehouse.FULL_NAME = 'gatehouse'
Gatehouse.BUILDING_TYPE = 'military'
Gatehouse.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Gatehouse.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Infirmary = class('Infirmary', Building)

Infirmary.FULL_NAME = 'infirmary'
Infirmary.BUILDING_TYPE = 'military'
Infirmary.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Infirmary.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Armory = class('Armory', Building)

Armory.FULL_NAME = 'armory'
Armory.BUILDING_TYPE = 'military'
Armory.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Armory.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Supply = class('Supply', Building)

Supply.FULL_NAME = 'supply'
Supply.BUILDING_TYPE = 'military'
Supply.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Supply.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Barracks = class('Barracks', Building)

Barracks.FULL_NAME = 'barracks'
Barracks.BUILDING_TYPE = 'military'
Barracks.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Barracks.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

return {Gatehouse, Infirmary, Armory, Supply, Barracks}