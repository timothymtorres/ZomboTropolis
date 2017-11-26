local class = require('code.libs.middleclass')

local decay = class('decay')

local MAX_TIME = 1023

function decay:initialize()
  self.time = 0
end

function decay:add(amount, player)
  self.time = math.max(self.time + amount, 0)
  if self.time >= MAX_TIME then
    player:killed('decay')
  end
end

function decay:elapse(player, time)
  self:add(time, player)
end

function decay:getTime() return self.time end

return decay