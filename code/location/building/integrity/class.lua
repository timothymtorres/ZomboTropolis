local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local integrity = class('integrity')

local RANSACK_DMG_CAP = 10
--local RUIN_DMG_CAP    do we need to put a cap on max ruin dmg dealt?
local BUILDING_MAX_HP = 60 --{60, 80, 100, 120, 145, 170, 195, 220, 255} this is HP table based on building sizes

function integrity:initialize(building)
  self.building = building
  self.hp = BUILDING_MAX_HP -- Update this later to the size of the building (all buildilng are 1 tile sized right now)
end

function integrity:updateHP(num)
  self.hp = math.min( math.max(self.hp+num, 0), BUILDING_MAX_HP) 
  self:updateDesc()  
end

function integrity:isRuinActive() end

function integrity:getState() end

function integrity:updateDesc() end

return integrity