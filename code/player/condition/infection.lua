local class = require('code.libs.middleclass')

local infection = class('infection')

local MAX_TIME = 1023

function infection:initialize()
  self.time = 0
end

function infection:add(amount, player)
  self.time = math.max(self.time + amount, 0)
  if self.time >= MAX_TIME then
    player:killed('infection')
  end
end

function infection:elapse(player, time)
  self:add(time, player)
end

function infection:getTime() return self.time end

return infection

--[[
you have 0 infection = aka 21 days to live
you get attacked lose about 30 hp from bites
ie... make infection 1d2, 1d3, 1d4 from bites?

21 days
knockoff @ 60 hp (ie. 59 damage) should remove 5/7 days?   
7x50 = 350
5x50 = 250
3x50 = 150
--]]