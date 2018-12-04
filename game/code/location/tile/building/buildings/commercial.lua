local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local Gas = class('Gas', Building)

Gas.FULL_NAME = 'gas station'
Gas.BUILDING_TYPE = 'misc'
Gas.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Gas.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Shop = class('Shop', Building)

Shop.FULL_NAME = 'shop'
Shop.BUILDING_TYPE = 'misc'
Shop.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Shop.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

-- MALL WILL ACT DIFFERENTLY FROM OTHER BUILDINGS
local Mall = class('Mall', Building)

Mall.FULL_NAME = 'shopping mall'
Mall.BUILDING_TYPE = 'commercial'
Mall.search_odds = {outside = Building.search_odds.outside, inside = 0.60}
Mall.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  60%
      Machate = .10,
          Bat = .20,
          Bow = .10,
     Crossbow = .10,
        Knife = .10,

      -- AMMO =  30%
       Quiver = .30,

      -- MISC =  10%
    Newspaper = .10, 
  }
}

-------------------------------------------------------------------

return {Gas, Shop, Mall}