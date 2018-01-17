local class = require('code.libs.middleclass')

local Network = class('Network')

function Network:initialize() end

function Network:insert(listener, channel) self[channel][listener] = listener end  -- probably need to set this to a weak table

function Network:remove(listener, channel) self[channel][listener] = nil end

function Network:check(listener, channel) return self[channel][listener] end

function Network:transmit(speaker, channel, message)
  local event, settings = {'network', speaker, channel}, {stage='inside'}
  local msg = tostring(speaker)..' ('..channel..'): '..message -- in UD the speaker is omitted It's [channel]: "Message here"

  for listener in pairs(self[channel]) do 
  	if tostring(listener) == 'building' then listener:broadcastEvent(msg, event, settings)
  	elseif listener ~= speaker then listener.log:insert(msg, event)
  	end
  end
end

return Network