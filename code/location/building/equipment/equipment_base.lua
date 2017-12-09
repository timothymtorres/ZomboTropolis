local class = require('code.libs.middleclass')

local Equipment = class('EquipmentBase')
local MAX_HP = 8

function EquipmentBase:initialize(building) 
  self.hp = MAX_HP
  self.building = building
end

function EquipmentBase:destroy()
  -- update building stuff... (ie. power out if generator, player notification event)
end

function EquipmentBase:updateHP(num)
  self.hp = math.min(math.max(self.hp + num, 0), max_hp) 
  if self.hp == 0 then self:destroy() end  
end

function EquipmentBase:getHP() return self.hp end

function EquipmentBase:getBuilding() return self.building end

--[[
  self.generator = 0        -- 1 bit {exist}, 3 bit {08hp}, 4 bit {fuel} 
  self.transmitter = 0      -- 1 bit {exist}, 3 bit {08hp}, 10 bit {radio freq}
  self.terminal = 0         -- 1 bit {exist}, 3 bit {08hp},   
--]]

return EquipmentBase