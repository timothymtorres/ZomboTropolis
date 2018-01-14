local Network = require('code.server.network.network')
local class = require('code.libs.middleclass')

local Hivemind = class('Hivemind', Network)

function Hivemind:initialize()
  for i=1, 256 do self[i] = {} end
end

function Hivemind:transmit(channel, speaker, message)
  local event = {'hivemind', speaker}

  for listener in pairs(self[channel]) do
  	listener.log:insert(tostring(speaker)..': '..message, event)
  end
end

return Hivemind