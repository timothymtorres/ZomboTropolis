local class = require('code.libs.middleclass')

local Network = class('Network')

function Network:initialize() end

function Network:insert(channel, listener) self[channel][listener] = listener end

function Network:remove(channel, listener) self[channel][listener] = nil end

function Network:transmit(channel, speaker, message)
  local event, settings = {'network', speaker}, {stage='inside'}

  for listener in pairs(self[channel]) do 
  	if tostring(listener) == 'building' then listener:broadcastEvent(message, event, settings)
  	else listener.log:insert(tostring(speaker)..': '..message, event) -- listener is a player then
  	end
  end
end

return Network