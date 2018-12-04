local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local Apartment = class('Apartment', Building)

Apartment.FULL_NAME = 'apartment'
Apartment.BUILDING_TYPE = 'residential'
Apartment.titles = {'apartment', 'hotel'}
Apartment.search_odds = {outside = Building.search_odds.outside, inside = 0.10}
Apartment.item_chance = {
  outside = Building.item_chance.outside,
  inside =  {
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
}

-------------------------------------------------------------------

return {Apartment}