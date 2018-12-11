local class = require('code.libs.middleclass')
local Building = require('code.location.tile.building.building')

-------------------------------------------------------------------

local PD = class('PD', Building)

PD.FULL_NAME = 'police department'
PD.BUILDING_TYPE = 'government'
PD.search_odds = {outside = Building.search_odds.outside, inside = 0.50}
PD.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
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
}

-------------------------------------------------------------------

local FD = class('FD', Building)

FD.FULL_NAME = 'fire department'
FD.BUILDING_TYPE = 'government'
FD.search_odds = {outside = Building.search_odds.outside, inside = 0.50}
FD.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
   -- MEDICAL =  25%
          FAK = .05,
      Bandage = .20,

   -- WEAPONS =  40%
        Knife = .10,
        Flare = .20, 
      Crowbar = .10,

      -- MISC =  10%
    Newspaper = .10,

      -- GEAR =  25%
        Radio = .20,
          GPS = .05, 
  }
}

-------------------------------------------------------------------

local Hospital = class('Hospital', Building)

Hospital.FULL_NAME = 'hospital'
Hospital.BUILDING_TYPE = 'government'
Hospital.search_odds = {outside = Building.search_odds.outside, inside = 0.50}
Hospital.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
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
}

-------------------------------------------------------------------

local Lab = class('Lab', Building)

Lab.FULL_NAME = 'lab'
Lab.BUILDING_TYPE = 'government'
Lab.search_odds = {outside = Building.search_odds.outside, inside = 0.50}
Lab.item_chance = {
  outside = Building.item_chance.outside,
  inside = {
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
}

return {PD, FD, Hospital, Lab}