local class = require('code.libs.middleclass')

local EquipmentBase = class('EquipmentBase')
local MAX_HP = 8

function EquipmentBase:initialize(building) 
  self.hp = MAX_HP
  self.building = building
end

function EquipmentBase:destroy()
  local building = self.building
  local machine = string.lower(self.class.name)

  building[machine] = nil
  -- update building stuff... (ie. power out if generator, player notification event, broadcast event, etc.)
end

function EquipmentBase:updateHP(num)
  self.hp = math.min(math.max(self.hp + num, 0), max_hp) 
  if self.hp == 0 then self:destroy() end  
end

function EquipmentBase:getHP() return self.hp end

--[[
  self.generator = 0        -- 1 bit {exist}, 3 bit {08hp}, 4 bit {fuel} 
  self.transmitter = 0      -- 1 bit {exist}, 3 bit {08hp}, 10 bit {radio freq}
  self.terminal = 0         -- 1 bit {exist}, 3 bit {08hp},   
--]]

return EquipmentBase