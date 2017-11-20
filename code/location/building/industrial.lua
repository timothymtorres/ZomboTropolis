local class =           require('code.libs.middleclass')
local Building = require('code.location.building.building')

-------------------------------------------------------------------

local Warehouse = class('Warehouse', Building)

Warehouse.FULL_NAME = 'warehouse'
Warehouse.BUILDING_TYPE = 'industrial'
Warehouse.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.40}
Warehouse.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  70%
      Crowbar = .20,
       Sledge = .10,
      Toolbox = .40,

      -- MISC =  10%
    Newspaper = .10,

     -- EQUIP =  20%
    Generator = .05,
         Fuel = .15, 
  }
}

-------------------------------------------------------------------

local Factory = class('Factory', Building)

Factory.FULL_NAME = 'factory'
Factory.BUILDING_TYPE = 'industrial'
Factory.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.40}
Factory.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  70%
      Crowbar = .20,
       Sledge = .10,
      Toolbox = .40,

      -- MISC =  10%
    Newspaper = .10,

     -- EQUIP =  20%
    Generator = .05,
         Fuel = .15, 
  }
}

return {Warehouse, Factory}