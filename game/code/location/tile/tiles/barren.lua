local class = require('code.libs.middleclass')
local Tile = require('code.location.tile.tile')

-------------------------------------------------------------------

local Land = class('Land', Tile)

Land.FULL_NAME = 'land'


-------------------------------------------------------------------

local Street = class('Street', Tile)

Street.FULL_NAME = 'street'

-------------------------------------------------------------------

local Cemetary = class('Cemetary', Tile)

Cemetary.FULL_NAME = 'cemetary'

-------------------------------------------------------------------

local Wasteland = class('Wasteland', Tile)

Wasteland.FULL_NAME = 'wasteland'

-------------------------------------------------------------------

local Runway = class('Runway', Tile)

Runway.FULL_NAME = 'runway'

-------------------------------------------------------------------

local Forest = class('Forest', Tile)

Forest.FULL_NAME = 'forest'

-------------------------------------------------------------------

return {Land, Street, Cemetary, Wasteland, Runway, Forest}