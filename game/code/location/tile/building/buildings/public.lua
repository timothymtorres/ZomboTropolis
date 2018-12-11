local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local Library = class('Library', Building)

Library.FULL_NAME = 'library'
Library.BUILDING_TYPE = 'public'
Library.titles = {'library', 'school', 'college'}
Library.search_odds = {outside = Building.search_odds.outside, inside = 0.20}
Library.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  02%
          Bat = .02,  
    
      -- MISC =  90%
    Newspaper = .20,
         Book = .70,
    
      -- GEAR =  08%
   Flashlight = .08,  
  }
}

-------------------------------------------------------------------

local News = class('News', Building)

News.FULL_NAME = 'news'
News.BUILDING_TYPE = 'public'
News.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
News.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Museum = class('Museum', Building)

Museum.FULL_NAME = 'museum'
Museum.BUILDING_TYPE = 'misc'
Museum.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Museum.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}

-------------------------------------------------------------------

local Church = class('Church', Building)

Church.FULL_NAME = 'church'
Church.BUILDING_TYPE = 'misc'
Church.search_odds = {outside = Building.search_odds.outside, inside = 0.30}
Church.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
    Newspaper = 1.00,
  }
}


-------------------------------------------------------------------


return {Library, News, Museum, Church}