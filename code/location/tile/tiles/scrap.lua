local class =           require('code.libs.middleclass')
local TileBase = 		require('code.location.tile.tile_base')

-------------------------------------------------------------------

local Carpark = class('Carpark', TileBase)

Carpark.FULL_NAME = 'carpark'

-------------------------------------------------------------------

local Junkyard = class('Junkyard', TileBase)

Junkyard.FULL_NAME = 'junkyard'

-------------------------------------------------------------------

return {Carpark, Junkyard}