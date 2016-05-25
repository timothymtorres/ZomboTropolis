local class = require('code.libs.middleclass')

local equipment = class('equipment')
local max_hp = 7

function equipment:initialize(building) 
  self.hp = 0
  self.building = building
end

function equipment:install() self.hp = max_hp end

function equipment:destroy()
  self.hp = 0
  -- update building stuff... (ie. power out if generator, player notification event)
end

function equipment:updateHP(num)
  self.hp = math.min(math.max(self.hp + num, 0), max_hp) 
  if self.hp <= 0 then self:destroy() end  
end

function equipment:isPresent() return self.hp > 0 end

function equipment:getClass() return self.class end

function equipment:getClassName() return tostring(self.class) end

function equipment:getName() return self.name end

function equipment:getHP() return self.hp end

function equipment:getBuilding() return self.building end

--[[
  self.generator = 0        -- 1 bit {exist}, 3 bit {08hp}, 4 bit {fuel} 
  self.transmitter = 0      -- 1 bit {exist}, 3 bit {08hp}, 10 bit {radio freq}
  self.terminal = 0         -- 1 bit {exist}, 3 bit {08hp},   
  
  equipment flags
  
  building.equipment:getFlags()
  building.barricade:getFlags()
  
  anyway
  
  generator = {
    exist = 1,
    see that's the problem... NO FLAGS... just fields?  hmmmmmm not a flag system,
    you are compressing/decompressing the data....... then if that's the case
  }
--]]

return equipment