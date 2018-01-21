local class = require('code.libs.middleclass')

local channel = class('channel')

function channel:initialize() for i=1, 1024 do self[i] = {} end end

function channel:insert(freq, receiver) self[freq][receiver] = true end

function channel:remove(freq, receiver) self[freq][receiver] = nil end

function channel:transmit(freq, speaker, message, condition)
  for receiver in pairs(self[freq]) do receiver:listen(speaker, message, channel) end
end

-- channel NEEDS TO BE A GLOBAL
return channel