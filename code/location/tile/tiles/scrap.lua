local class =           require('code.libs.middleclass')
local Tile = 		require('code.location.tile.tile')

-------------------------------------------------------------------

local Carpark = class('Carpark', Tile)

Carpark.FULL_NAME = 'carpark'

-------------------------------------------------------------------

local Junkyard = class('Junkyard', Tile)

Junkyard.FULL_NAME = 'junkyard'

-------------------------------------------------------------------

return {Carpark, Junkyard}