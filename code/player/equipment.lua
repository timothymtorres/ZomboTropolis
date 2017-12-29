local class = require('code.libs.middleclass')
local Equipment = class('Equipment')

-- clothing slots for (feet, hands, eye, mask, helmet, back, suit)
-- armor slot for (exo_suit)

function Equipment:initialize(player)
  self.player = player
end

function Equipment:add(section, object)
  self[section] = object
end

function Equipment:remove(section) self[section] = nil end

function Equipment:isPresent(section) return self[section] end

return Equipment