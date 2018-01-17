local Network = require('code.server.network.network')
local class = require('code.libs.middleclass')

local HumanNetwork = class('HumanNetwork', Network)

function HumanNetwork:initialize() 
  for channel=1, 1024 do self[channel] = {} end
end

function HumanNetwork:transmit(channel, speaker, message)
  local event, settings = {'network', channel, speaker}, {stage='inside'}
  local msg = tostring(speaker)..' ('..channel..'): '..message

  for listener in pairs(self[channel]) do 
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	else listener.log:insert(msg, event) -- listener is a player then
  	end
  end
end

return HumanNetwork