local Network = require('code.server.network.network')
local class = require('code.libs.middleclass')

local Radio = class('Radio', Network)

function Radio:initialize() 
  for i=1, 1024 do self[i] = {} end
end

function Radio:transmit(channel, speaker, message)
  local event, settings = {'network', channel, speaker}, {stage='inside'}
  local msg = tostring(speaker)..' ('..channel..'): '..message

  for listener in pairs(self[channel]) do 
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	else listener.log:insert(msg, event) -- listener is a player then
  	end
  end
end

return Radio