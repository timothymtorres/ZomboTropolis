local class = require('code.libs.middleclass')

local barrier = class('barrier')  

--[[
self.barricade = {hp=0, desc=0}   -- 1 bit {exist}, 6 bit {63hp}, 3 bit {desc}
self.door = {hp=4, state='closed'}-- 1 bit {exist}, 2 bit {03hp}, 1 bit {state}
--]]

function barrier:initialize() end  

function barrier:getHP() return self.hp end

function barrier:updateHP(num)   
  self.hp = math.min( math.max(self.hp+num, 0), self.max_hp)
  self:updateDesc()
end

return barrier