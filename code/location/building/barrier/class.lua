local class = require('code.libs.middleclass')

local barrier = class('barrier')  

--[[  
self.barricade = {hp=0, desc=0}   -- 1 bit {exist}, 6 bit {64hp}, 3 bit {desc}
self.door = {hp=4, state='closed'}-- 1 bit {exist}, 2 bit {04hp}, 1 bit {state}
--]]

function barrier:initialize() end  

function barrier:getHP() return self.hp end

function barrier:updateHP(num) 
  for k,v in pairs(self) do print(k,v) end
  print(self.static)
  print(self.max_hp)
  
  self.hp = math.min( math.max(self.hp+num, 0), self.max_hp) 
end

return barrier