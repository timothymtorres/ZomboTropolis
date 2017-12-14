local class =           require('code.libs.middleclass')
local Building = require('code.location.building.building')

-------------------------------------------------------------------

local News = class('News', Building)

News.FULL_NAME = 'news'
News.BUILDING_TYPE = 'commercial'
News.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.30}
News.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Sport = class('Sport', Building)

Sport.FULL_NAME = 'sporting goods'
Sport.BUILDING_TYPE = 'commercial'
Sport.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.30}
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
Bar.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.20}
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

-- MALL WILL ACT DIFFERENTLY FROM OTHER BUILDINGS
local Mall = class('Mall', Building)

Mall.FULL_NAME = 'shopping mall'
Mall.BUILDING_TYPE = 'commercial'
Mall.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.60}
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

return {News, Sport, Bar, Mall}