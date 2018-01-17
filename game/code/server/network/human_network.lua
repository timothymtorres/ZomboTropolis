local Network = require('code.server.network.network')
local class = require('code.libs.middleclass')

local HumanNetwork = class('HumanNetwork', Network)

function HumanNetwork:initialize() 
  for channel=1, 1024 do self[channel] = {} end
end

return HumanNetwork