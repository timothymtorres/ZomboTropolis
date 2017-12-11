local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local Immunity = class('Immunity')

local MAX_TIME = 511

function Immunity:initialize(player, time)
  self.player = player
  self.ticks = math.min(MAX_TIME, time)

  if player.status_condition:isActive('infection') then player.log:append('You feel the infection become dormant.') end  
end

function Immunity:add(time) self.ticks = math.min(MAX_TIME, self.ticks + time) end

function Immunity:elapse(time)
  self.ticks = math.max(self.ticks - time, 0)
  if self.ticks == 0 then
    self.player.status_condition:remove('immunity')
    --player.log:append('You feel your immunity to resist infection fade.')
  end
end

return Immunity