local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local integrity = class('integrity')

local BUILDING_MAX_HP = 20 --{15, 20, 30, ???} this is a HP table based on building sizes
local RANSACK_VALUE = BUILDING_MAX_HP - 10
local MAX_DECAY = -60

function integrity:initialize(building)
  self.building = building
  self.hp = BUILDING_MAX_HP -- Update this later to the size of the building (all buildilng are 1 tile sized right now)
end

function integrity:updateHP(num)
  self.hp = math.min(math.max(self.hp+num, MAX_DECAY), BUILDING_MAX_HP)) 
  
  if self.hp >= 0 or self.hp == MAX_DECAY then
    --remove building from decay list
  if self.hp < 0 then
    --add building to decay list    
  end
  
  self:updateDesc() 
end

function integrity:canModify(player)  -- possibly move all or parts of this code to criteria.toolbox and critera.ransack?
  local n_humans = self.building:countPlayers('human', 'inside')
  local n_zombies = self.building:countPlayers('zombie', 'inside')
  
  if player:isMobType('human') then 
    if self:isState('ransacked') then return true
    elseif self:isState('ruined') and player.skills:check('renovate') and n_zombies == 0 then return true
    end 
  elseif player:isMobType('zombie') then
    -- because zombies we don't want zombies to ransack past 0, we have RANSACK_VALUE at 10 which prevents integrity from going into ruin state
    if self.hp > RANSACK_VALUE then return true
    elseif self.hp >= 0 and player.skills:check('ruin') and n_humans == 0 then return true
    end       
  end
  
  return false
end

function integrity:isState(setting) return self:getState() == setting end

function integrity:getState() 
  local integrity_is_full = self.hp == BUILDING_MAX_HP
  local integrity_within_ransack_range = self.hp >= 0 
  local integrity_within_ruin_range = self.hp < 0
  return (integrity_is_full and 'intact') or (integrity_within_ransack_range and 'ransacked') or (integrity_within_ruin_range and 'ruined') 
end

--function integrity:getHP() return self.hp end

function integrity:updateDesc() end

return integrity