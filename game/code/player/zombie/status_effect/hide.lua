local class = require('code.libs.middleclass')

local Hide = class('Hide')

function Hide:initialize(player)
  self.player = player
end

return Hide