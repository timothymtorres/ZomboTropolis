local class =           require('code.libs.middleclass')

-------------------------------------------------------------------

local Street = class('Street', TileBase)

Street.FULL_NAME = 'street'

-------------------------------------------------------------------

local Cemetary = class('Cemetary', TileBase)

Cemetary.FULL_NAME = 'cemetary'

-------------------------------------------------------------------

local Wasteland = class('Wasteland', TileBase)

Wasteland.FULL_NAME = 'wasteland'

-------------------------------------------------------------------

return = {Street, Cemetary, Wasteland}