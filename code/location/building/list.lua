-- external desc works as follows
-- You are standing outside the [building title], a [story] [adjective] [color] [material] [details] [surroundings].

--[[
  full_name = 'insert name'
  building_type = residential/government/industrial/commercial/generic
  door_missing = true/nil
**internal_desc = {desc1, desc2, desc3, ..., selection_range = num/nil}/nil   (selection_range is optional)
**powered_desc = {desc1, desc2, desc3, ..., selection_range = num/nil}/nil    (selection_range is optional)
  search_odds = {internal = num, external = num}/nil  
  item_chance = {item = .00 chance}
 
** - desc string must start with '... ' if it's a continuation of a sentence (comma inserted before string), otherwise string will be a new sentence. (period inserted before string)
** - selection_range is the range for the description that will be randomly selected  (ie. math.random(1, desc[selection_range]), this is because some descs for unique locations will be outside of the selection range  
--]]

--[[-----------  SEARCH ODDS  ------------ 

mall = 60%
PD, FD, hospital = 50%
factory = 30-40%
library/school = 20%
home = 10%

--]]-----------  SEARCH ODDS  ------------

--[[
---  GENERIC
--]]

--[[
---  RESIDENTIAL
--]]



building.apartment = {}
building.apartment.full_name = 'apartment'
building.apartment.building_type = 'residential'
building.apartment.search_odds = {outside = Building.search_odds.OUTSIDE, inside = 0.10}
building.apartment.item_chance = {}
building.apartment.item_chance.outside = Building.item_chance.outside
building.apartment.item_chance.inside =  {
 -- MEDICAL =  15%
        FAK = .05,
    Bandage = .10,

 -- WEAPONS =  30%
     Pistol = .03,
    Shotgun = .02,
        Bat = .15,
      Knife = .10,

    -- MISC =  40%
  Newspaper = .10,
       Book = .15,
     Bottle = .15,

    -- GEAR =  15%
      Radio = .05,
      Phone = .10, 
}

building.hotel = {}
building.hotel.full_name = 'hotel'
building.hotel.building_type = 'residential'
building.hotel.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.20}
building.hotel.item_chance = {}
building.hotel.item_chance.outside = building.default.item_chance.outside
building.hotel.item_chance.inside =  {
 -- MEDICAL =  15%
        FAK = .05,
    Bandage = .10,

 -- WEAPONS =  30%
     Pistol = .03,
    Shotgun = .02,
        Bat = .15,
      Knife = .10,

    -- MISC =  40%
  Newspaper = .10,
       Book = .15,
     Bottle = .15,

    -- GEAR =  15%
      Radio = .05,
      Phone = .10, 
}

--[[
---  GOVERNMENT
--]]

building.PD = {}
building.PD.full_name = 'police department'
building.PD.building_type = 'government'
building.PD.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.50}
building.PD.item_chance = {}
building.PD.item_chance.outside = building.default.item_chance.outside
building.PD.item_chance.inside = {
   -- WEAPONS =  24%
       Pistol = .16,
      Shotgun = .08,

      -- AMMO =  48%
     Magazine = .32,
        Shell = .16,
    
   -- GADGETS =  18%
        Radio = .13,
          GPS = .05,

      -- MISC =  10%
    Newspaper = .10,
}

building.FD = {}
building.FD.full_name = 'fire department'
building.FD.building_type = 'government'
building.FD.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.50}
building.FD.item_chance = {}
building.FD.item_chance.outside = building.default.item_chance.outside
building.FD.item_chance.inside = {
 -- MEDICAL =  25%
        FAK = .05,
    Bandage = .20,

 -- WEAPONS =  40%
        Axe = .10,
      Flare = .20, 
    Crowbar = .10,

    -- MISC =  10%
  Newspaper = .10,

    -- GEAR =  25%
      Radio = .20,
        GPS = .05, 
}

building.hospital = {}
building.hospital.full_name = 'hospital'
building.hospital.building_type = 'government'
building.hospital.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.50}
building.hospital.item_chance = {}
building.hospital.item_chance.outside = building.default.item_chance.outside
building.hospital.item_chance.inside = {
 -- MEDICAL =  75%
  --      FAK = .25,
  --  Bandage = .50, 
    Vaccine = .01,
    Syringe = .89,

 -- WEAPONS =  10%
  --    Knife = .90,

    -- MISC =  10%
  Newspaper = .10, 
}

building.courthouse = {}
building.courthouse.full_name = 'courthouse'
building.courthouse.building_type = 'government'
building.courthouse.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.30}
building.courthouse.item_chance = {}
building.courthouse.item_chance.outside = building.default.item_chance.outside
building.courthouse.item_chance.inside = {
  -- MEDICAL
    Bandage = .10,
  
  Newspaper = .90,
}

--[[
---  INDUSTRIAL
--]]


building.warehouse = {}
building.warehouse.full_name = 'warehouse'
building.warehouse.building_type = 'industrial'
building.warehouse.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.40}
building.warehouse.item_chance = {}
building.warehouse.item_chance.outside = building.default.item_chance.outside
building.warehouse.item_chance.inside = {
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

building.factory = {}
building.factory.full_name = 'factory'
building.factory.building_type = 'industrial'
building.factory.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.40}
building.factory.item_chance = {}
building.factory.item_chance.outside = building.default.item_chance.outside
building.factory.item_chance.inside = {
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

--[[
---  COMMERCIAL
--]]

building.news = {}
building.news.full_name = 'news'
building.news.building_type = 'commercial'
building.news.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.30}
building.news.item_chance = {}
building.news.item_chance.outside = building.default.item_chance.outside
building.news.item_chance.inside = {
  Newspaper = 1.00,
}

building.sport = {}
building.sport.full_name = 'sporting goods'
building.sport.building_type = 'commercial'
building.sport.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.30}
building.sport.item_chance = {}
building.sport.item_chance.outside = building.default.item_chance.outside
building.sport.item_chance.inside = {
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

building.bar = {}
building.bar.full_name = 'bar'
building.bar.building_type = 'commercial'
building.bar.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.20}
building.bar.item_chance = {}
building.bar.item_chance.outside = building.default.item_chance.outside
building.bar.item_chance.inside = {
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

-- MALL WILL ACT DIFFERENTLY FROM OTHER BUILDINGS
building.mall = {}
building.mall.full_name = 'shopping mall'
building.mall.building_type = 'commercial'
building.mall.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.60}
building.mall.item_chance = {}
building.mall.item_chance.outside = building.default.item_chance.outside
building.mall.item_chance.inside = {
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

--[[
---  PUBLIC
--]]

building.library = {}
building.library.full_name = 'public library'
building.library.building_type = 'public'
building.library.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.20}
building.library.item_chance = {}
building.library.item_chance.outside = building.default.item_chance.outside
building.library.item_chance.inside = {
    -- MISC =  95%
  Newspaper = .20,
       Book = .75,
  
    -- GEAR =  05%
      Phone = .05,
}

building.school = {}
building.school.full_name = 'school'
building.school.building_type = 'public'
building.school.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = 0.20}
building.school.item_chance = {}
building.school.item_chance.outside = building.default.item_chance.outside
building.school.item_chance.inside = {
 -- WEAPONS =  02%
        Bat = .02,  
  
    -- MISC =  90%
  Newspaper = .20,
       Book = .70,
  
    -- GEAR =  08%
      Phone = .08,  
}

return building