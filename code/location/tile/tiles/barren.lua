local class =           require('code.libs.middleclass')
local Tile = 		require('code.location.tile.tile')

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

return {Street, Cemetary, Wasteland}