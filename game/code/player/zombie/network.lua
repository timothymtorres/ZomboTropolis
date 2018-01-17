local class = require('code.libs.middleclass')
local ZombieNetwork = require('code.server.network.zombie_network')

local Network = class('Network')

function Network:initialize()
  self.channel = 1
end

function Network:update(channel)
  ZombieNetwork:remove(self.channel, player)
  ZombieNetwork:add(channel, player)
  self.channel = channel 
end

return Network