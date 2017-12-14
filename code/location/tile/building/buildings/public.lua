local class =           require('code.libs.middleclass')
local Building = require('code.location.building.building')

-------------------------------------------------------------------

local Library = class('Library', Building)

Library.FULL_NAME = 'public library'
Library.BUILDING_TYPE = 'public'
Library.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.20}
Library.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
      -- MISC =  95%
    Newspaper = .20,
         Book = .75,
    
      -- GEAR =  05%
        Phone = .05,
  }
}

-------------------------------------------------------------------

local School = class('School', Building)

School.FULL_NAME = 'school'
School.BUILDING_TYPE = 'public'
School.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.20}
School.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  02%
          Bat = .02,  
    
      -- MISC =  90%
    Newspaper = .20,
         Book = .70,
    
      -- GEAR =  08%
        Phone = .08,  
  }
}

-------------------------------------------------------------------

local College = class('College', Building)

College.FULL_NAME = 'college'
College.BUILDING_TYPE = 'public'
College.search_odds = {OUTSIDE = Building.search_odds.OUTSIDE, INSIDE = 0.20}
College.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- WEAPONS =  02%
          Bat = .02,  
    
      -- MISC =  90%
    Newspaper = .20,
         Book = .70,
    
      -- GEAR =  08%
        Phone = .08,  
  }
}

return {Library, School, College}