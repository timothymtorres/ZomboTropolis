local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local integrity = class('integrity')

local RANSACK_DMG_CAP = 10
--local RUIN_DMG_CAP    do we need to put a cap on max ruin dmg dealt?
local BUILDING_MAX_HP = 60 --{60, 80, 100, 120, 145, 170, 195, 220, 255} this is HP table based on building sizes

function integrity:initialize(building)
  self.building = building
  self.hp = BUILDING_MAX_HP -- Update this later to the size of the building (all buildilng are 1 tile sized right now)
  self.is_decay_active = false
end

function integrity:updateHP(num)
  self.hp = math.min( math.max(self.hp+num, 0), BUILDING_MAX_HP) 
  
  local is_integrity_ruined = self:getState() == 'ruined'
  local room_for_decay_available = self.hp == 0
  
  if is_integrity_ruined and room_for_decay_available then
    self.is_decay_active = true
    --add building to decay list
  else
    self.is_decay_active = false
    --remove building from decay list
  end
  
  self:updateDesc() 
end

function integrity:isDecaying() return self.is_decay_active end

local RANSACK_THRESHOLD = BUILDING_MAX_HP - RANSACK_DMG_CAP

function integrity:getState() 
  if self.hp == BUILDING_MAX_HP then return 'intact'
  elseif self.hp > RANSACK_THRESHOLD then return 'ransacked'
  elseif self.hp >= 0 then return 'ruined'
  --elseif self.hp == 0 then return 'ruined fully'
  end
end

function integrity:updateDesc() end

return integrity