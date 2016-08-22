local building = {}
building.external_desc = {
  odds = {adjective = .25, color = .50, details = .25, surroundings = .25},
  stories = {'three story', 'four story', 'five story'},
  adjective = {'narrow', 'tall', 'straight', 'curved', 'twisted', 'crooked', 'fire-scorched', 'burnt', 'scorched'},
  color = {'grey', 'yellow', 'white', 'vanilla', 'blue'}, 
  colored_material = {concrete = true, wooden = true, stone = true, slab = true, marble = true},
  material = {'glass', 'red-brick', 'concrete', 'wooden', 'slab', 'stone', 'steel', 'metal', 'metal and glass', 'ivory', 'marble'},
  details = {'revovling doors', 'boarded up windows', 'dusty windows', 'rounded windows', 'broken and dusty windows', 'broken windows', 'glass windows', 'tinted windows'},
  surroundings = {'surrounded by wrecked cars', 'surrounded by a metal fence', 'surrounded by trees', 'covered in vines', 'covered in moss', 'surrounded by a wooden fence'},
}

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

local OUTSIDE_SEARCH_ODDS, INSIDE_SEARCH_ODDS = .50, .15

--[[
---  GENERIC
--]]

building.default = {}
building.default.full_name = 'building'
building.default.building_type = 'generic'
building.default.search_odds = {outside = OUTSIDE_SEARCH_ODDS, inside = INSIDE_SEARCH_ODDS}
building.default.item_chance = {}
building.default.item_chance.inside =  {
 -- MEDICAL =  15%
        FAK = .05,
    bandage = .10,

 -- WEAPONS =  30%
     pistol = .03,
    shotgun = .02,
     hammer = .05,
        bat = .10,
      knife = .10,

    -- MISC =  40%
  newspaper = .10,
       book = .15,
     bottle = .15,

    -- GEAR =  15%
      radio = .05,
      phone = .10, 
}

--[[
---  RESIDENTIAL
--]]

building.apartment = {}
building.apartment.full_name = 'apartment'
building.apartment.building_type = 'residential'
building.apartment.search_odds = {inside = 0.10}
building.apartment.item_chance = {}
building.apartment.item_chance.inside =  {
 -- MEDICAL =  15%
        FAK = .05,
    bandage = .10,

 -- WEAPONS =  30%
     pistol = .03,
    shotgun = .02,
     hammer = .05,
        bat = .10,
      knife = .10,

    -- MISC =  40%
  newspaper = .10,
       book = .15,
     bottle = .15,

    -- GEAR =  15%
      radio = .05,
      phone = .10, 
}

building.hotel = {}
building.hotel.full_name = 'hotel'
building.hotel.building_type = 'residential'
building.hotel.search_odds = {inside = 0.20}
building.hotel.item_chance = {}
building.hotel.item_chance.inside =  {
 -- MEDICAL =  15%
        FAK = .05,
    bandage = .10,

 -- WEAPONS =  30%
     pistol = .03,
    shotgun = .02,
     hammer = .05,
        bat = .10,
      knife = .10,

    -- MISC =  40%
  newspaper = .10,
       book = .15,
     bottle = .15,

    -- GEAR =  15%
      radio = .05,
      phone = .10, 
}

--[[
---  GOVERNMENT
--]]

building.PD = {}
building.PD.full_name = 'police department'
building.PD.building_type = 'government'
building.PD.search_odds = {inside = 0.50}
building.PD.item_chance = {}
building.PD.item_chance.inside = {
   -- WEAPONS =  24%
       pistol = .16,
      shotgun = .08,

      -- AMMO =  48%
   pistol_mag = .32,
shotgun_shell = .16,
    
   -- GADGETS =  18%
        radio = .13,
          GPS = .05,

      -- MISC =  10%
    newspaper = .10,
}

building.FD = {}
building.FD.full_name = 'fire department'
building.FD.building_type = 'government'
building.FD.search_odds = {inside = 0.50}
building.FD.item_chance = {}
building.FD.item_chance.inside = {
 -- MEDICAL =  25%
        FAK = .05,
    bandage = .20,

 -- WEAPONS =  40%
        axe = .10,
      flare = .20,
    crowbar = .10,

    -- MISC =  10%
  newspaper = .10,

    -- GEAR =  25%
      radio = .20,
        GPS = .05, 
}

building.hospital = {}
building.hospital.full_name = 'hospital'
building.hospital.building_type = 'government'
building.hospital.search_odds = {inside = 0.50, outside = OUTSIDE_SEARCH_ODDS}
building.hospital.item_chance = {}
building.hospital.item_chance.inside = {
 -- MEDICAL =  75%
  --      FAK = .25,
  --  bandage = .50, 

 -- WEAPONS =  10%
      knife = .90,

    -- MISC =  10%
  newspaper = .10, 
}

building.courthouse = {}
building.courthouse.full_name = 'courthouse'
building.courthouse.building_type = 'government'
building.courthouse.search_odds = {inside = 0.30, outside = OUTSIDE_SEARCH_ODDS}
building.courthouse.item_chance = {}
building.courthouse.item_chance.inside = {
  -- MEDICAL
    bandage = .10,
  
  newspaper = .90,
}

--[[
---  INDUSTRIAL
--]]


building.warehouse = {}
building.warehouse.full_name = 'warehouse'
building.warehouse.building_type = 'industrial'
building.warehouse.search_odds = {inside = 0.40}
building.warehouse.item_chance = {}
building.warehouse.item_chance.inside = {
 -- WEAPONS =  70%
    crowbar = .20,
     sledge = .10,
    toolbox = .20,
     hammer = .20,

    -- MISC =  10%
  newspaper = .10,

   -- EQUIP =  20%
  generator = .05,
       fuel = .15, 
}

building.factory = {}
building.factory.full_name = 'factory'
building.factory.building_type = 'industrial'
building.factory.search_odds = {inside = 0.40}
building.factory.item_chance = {}
building.factory.item_chance.inside = {
 -- WEAPONS =  70%
    crowbar = .20,
     sledge = .10,
    toolbox = .20,
     hammer = .20,

    -- MISC =  10%
  newspaper = .10,

   -- EQUIP =  20%
  generator = .05,
       fuel = .15, 
}

--[[
---  COMMERCIAL
--]]

building.news = {}
building.news.full_name = 'news'
building.news.building_type = 'commercial'
building.news.search_odds = {inside = 0.30}
building.news.item_chance = {}
building.news.item_chance.inside = {
  newspaper = 1.00,
}

building.sport = {}
building.sport.full_name = 'sporting goods'
building.sport.building_type = 'commercial'
building.sport.search_odds = {inside = 0.30}
building.sport.item_chance = {}
building.sport.item_chance.inside = {
 -- WEAPONS =  60%
    machate = .10,
        bat = .20,
        bow = .10,
   crossbow = .10,
      knife = .10,

    -- AMMO =  30%
     quiver = .30,

    -- MISC =  10%
  newspaper = .10, 
}

building.bar = {}
building.bar.full_name = 'bar'
building.bar.building_type = 'commercial'
building.bar.search_odds = {inside = 0.20}
building.bar.item_chance = {}
building.bar.item_chance.inside = {
   -- WEAPONS =  30%
      shotgun = .10,
          bat = .05,
        knife = .15,

      -- AMMO =  25%
shotgun_shell = .25,

      -- MISC =  45%
    newspaper = .10,
       bottle = .30,
        phone = .05,
}

-- MALL WILL ACT DIFFERENTLY FROM OTHER BUILDINGS
building.mall = {}
building.mall.full_name = 'shopping mall'
building.mall.building_type = 'commercial'
building.mall.search_odds = {inside = 0.60}
building.mall.item_chance = {}
building.mall.item_chance.inside = {
 -- WEAPONS =  60%
    machate = .10,
        bat = .20,
        bow = .10,
   crossbow = .10,
      knife = .10,

    -- AMMO =  30%
     quiver = .30,

    -- MISC =  10%
  newspaper = .10, 
}

--[[
---  PUBLIC
--]]

building.library = {}
building.library.full_name = 'public library'
building.library.building_type = 'public'
building.library.search_odds = {inside = 0.20}
building.library.item_chance = {}
building.library.item_chance.inside = {
    -- MISC =  95%
  newspaper = .20,
       book = .75,
  
    -- GEAR =  05%
      phone = .05,
}

building.school = {}
building.school.full_name = 'school'
building.school.building_type = 'public'
building.school.search_odds = {inside = 0.20}
building.school.item_chance = {}
building.school.item_chance.inside = {
 -- WEAPONS =  02%
        bat = .02,  
  
    -- MISC =  90%
  newspaper = .20,
       book = .70,
  
    -- GEAR =  08%
      phone = .08,  
}

return building