local class = require('code.libs.middleclass')

local Network = class('Network')

function Network:initialize() end

function Network:insert(channel, listener) self[channel][listener] = listener end

function Network:remove(channel, listener) self[channel][listener] = nil end

function Network:check(channel, listener) return self[channel][listener] end

return Network