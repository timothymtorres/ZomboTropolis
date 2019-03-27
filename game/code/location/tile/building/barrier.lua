local class = require('code.libs.middleclass')

local Barrier = class('Barrier')  

--[[
self.barricade = {hp=0, desc=0}   -- 1 bit {exist}, 6 bit {63hp}, 3 bit {desc}
self.door = {hp=4, state='closed'}-- 1 bit {exist}, 2 bit {03hp}, 1 bit {state}
--]]

function Barrier:initialize() end  

function Barrier:getHP() return self.hp end

function Barrier:updateHP(num)   
  self.hp = math.min( math.max(self.hp+num, 0), self.max_hp)
  self:updateDesc()
end

function Barrier:setHealth(num)
  self.hp = math.min( math.max(num, 0), self.max_hp)
end

function Barrier:isPresent() return self.hp > 0 end

return Barrier