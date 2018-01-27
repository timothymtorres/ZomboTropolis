local class = require('code.libs.middleclass')

local Integrity = class('Integrity')

function Integrity:initialize(building)
  self.building = building
  self.hp = building.MAX_INTEGRITY
end

function Integrity:updateHP(num)
  local max_hp, max_decay = self.building.MAX_INTEGRITY, -1*self.building.MAX_INTEGRITY 

  self.hp = math.min(math.max(self.hp+num, max_decay), max_hp)
  
  if self.hp > 0 or self.hp == max_decay then
    --remove building from decay list
  elseif self.hp <= 0 then
    --add building to decay list    
  end
end

function Integrity:canRepair(player)
  if self:isState('ransacked') then return true
  elseif self:isState('ruined') then
    local p_building = player:getTile()  
    local n_zombies = p_building:countPlayers('zombie', 'inside')    
    if player.skills:check('renovate') and n_zombies == 0 then return true end
  end
  return false
end

function Integrity:canModify(player)  -- possibly move all or parts of this code to criteria.toolbox and critera.ransack?
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

function Integrity:isState(setting) return self:getState() == setting end

function Integrity:getState() 
  local integrity_is_full = self.hp == self.building.MAX_INTEGRITY
  local integrity_is_ransacked = self.hp > 0 
  return (integrity_is_full and 'intact') or (integrity_is_ransacked and 'ransacked') or 'ruined' 
end

function Integrity:getHP() return self.hp end

return Integrity