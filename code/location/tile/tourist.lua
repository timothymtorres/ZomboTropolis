local class =           require('code.libs.middleclass')

-------------------------------------------------------------------

local Monument = class('Monument', TileBase)

Monument.FULL_NAME = 'monument'

-------------------------------------------------------------------

local Park = class('Park', TileBase)

Park.FULL_NAME = 'park'

-------------------------------------------------------------------


local Stadium = class('Stadium', TileBase)

Stadium.FULL_NAME = 'stadium'

-------------------------------------------------------------------

return {Monument, Park, Stadium}