local class = require('code.libs.middleclass')
local ServerNetwork = require('code.server.network')

local Network = class('Network')

function Network:initialize(player)
  self.player = player
  self.channel = 1
end

function Network:update(channel)
  ServerNetwork:remove(self.player, self.channel)
  ServerNetwork:insert(self.player, channel)
  self.channel = channel 
end

function Network:check(channel) return self.channel == channel end

function Network:transmit(msg) ServerNetwork:transmit(self.player, self.channel, msg) end

return Network