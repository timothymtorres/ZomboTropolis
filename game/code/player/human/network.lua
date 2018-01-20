local class = require('code.libs.middleclass')
local ServerNetwork = require('code.server.network')

local Network = class('Network')

function Network:initialize(player)
  self.player = player
  self.channel = setmetatable({}, {__mode='v'})
end

function Network:add(channel, radio) 
	self.channels[channel] = radio
	ServerNetwork:insert(self.player, channel) 
end

function Network:remove(channel) 
	self.channels[channel] = nil
	ServerNetwork:remove(self.player, channel) 
end

function Network:check(channel) return self.channel[channel] end

return Network