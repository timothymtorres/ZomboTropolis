local Network = require('code.server.network.network')
local class = require('code.libs.middleclass')

local ZombieNetwork = class('ZombieNetwork', Network)

function ZombieNetwork:initialize()
  for channel=1, 256 do self[channel] = {} end
end

return ZombieNetwork