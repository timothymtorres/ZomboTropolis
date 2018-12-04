local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local Sport = class('Sport', Building)

Sport.FULL_NAME = 'sporting goods'
Sport.BUILDING_TYPE = 'commercial'
Sport.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Sport.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  60%
      Machate = .10,
          Bat = .30,
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

local Bar = class('Bar', Building)

Bar.FULL_NAME = 'bar'
Bar.BUILDING_TYPE = 'commercial'
Bar.search_odds = {outside = Building.search_odds.outside, inside = 0.20}
Bar.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
     -- WEAPONS =  30%
        Shotgun = .10,
            Bat = .05,
          Knife = .15,

        -- AMMO =  25%
          Shell = .25,

        -- MISC =  45%
      Newspaper = .10,
         Bottle = .30,
          Phone = .05,
  }
}

-------------------------------------------------------------------



return {Sport, Bar}