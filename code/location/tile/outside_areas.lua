local Street = class('Street', TileBase)

Street.FULL_NAME = 'street'

-------------------------------------------------------------------

local Cemetary = class('Cemetary', TileBase)

Cemetary.FULL_NAME = 'cemetary'

-------------------------------------------------------------------

local Monument = class('Monument', TileBase)

Monument.FULL_NAME = 'monument'

-------------------------------------------------------------------

local Park = class('Park', TileBase)

Park.FULL_NAME = 'park'

-------------------------------------------------------------------

local Wasteland = class('Wasteland', TileBase)

Wasteland.FULL_NAME = 'wasteland'

-------------------------------------------------------------------

local Stadium = class('Stadium', TileBase)

Stadium.FULL_NAME = 'stadium'

-------------------------------------------------------------------

local Junkyard = class('Junkyard', TileBase)

Junkyard.FULL_NAME = 'junkyard'

-------------------------------------------------------------------

local Carpark = class('Carpark', TileBase)

Carpark.FULL_NAME = 'carpark'

-------------------------------------------------------------------

return {Street, Cemetary, Monument, Park, Wasteland, Stadium, Junkyard, Carpark}