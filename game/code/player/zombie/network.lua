local class = require('code.libs.middleclass')
local ZombieNetwork = require('code.server.network.zombie_network')

local Network = class('Network')

function Network:initialize(player)
  self.player = player
  self.channel = 1
end

function Network:update(channel)
  ZombieNetwork:remove(self.player, self.channel)
  ZombieNetwork:add(self.player, channel)
  self.channel = channel 
end

function Network:check(channel) return ZombieNetwork:check(self.player, channel) end

function Network:transmit(msg) ZombieNetwork:transmit(self.player, self.channel, msg) end

function Network:getChannelName(channel) return 'blah' end -- Setup a list of star constellations to return?

return Network