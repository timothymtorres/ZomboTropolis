local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')

-------------------------------------------------------------------

local Monument = class('Monument', Tile)

Monument.FULL_NAME = 'monument'

-------------------------------------------------------------------

local Park = class('Park', Tile)

Park.FULL_NAME = 'park'

-------------------------------------------------------------------


local Stadium = class('Stadium', Tile)

Stadium.FULL_NAME = 'stadium'

-------------------------------------------------------------------

return {Monument, Park, Stadium}