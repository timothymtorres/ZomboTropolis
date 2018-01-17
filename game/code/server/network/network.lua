local class = require('code.libs.middleclass')

local Network = class('Network')

function Network:initialize() end

function Network:insert(listener, channel) self[channel][listener] = listener end

function Network:remove(listener, channel) self[channel][listener] = nil end

function Network:check(listener, channel) return self[channel][listener] end

function Network:transmit(speaker, channel, message)
  local event, settings = {'network', speaker, channel}, {stage='inside'}
  local msg = tostring(speaker)..' ('..channel..'): '..message

  for listener in pairs(self[channel]) do 
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	else listener.log:insert(msg, event) -- listener is a player then
  	end
  end
end

return Network