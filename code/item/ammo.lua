local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')

 
--ammo[item].durability = 0  -- all ammo is single use??? Or nah?

local Magazine = class('Magazine', ItemBase)

Magazine.static = {
  FULL_NAME = 'pistol magazine',
  WEIGHT = 3,
  DURABILITY = 0,
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Shell = class('Shell', ItemBase)

Shell.static = {
  FULL_NAME = 'shotgun shell',
  WEIGHT = 2,
  DURABILITY = 0,
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Clip = class('Clip', ItemBase)

Clip.static = {
  FULL_NAME = 'rifle clip',
  WEIGHT = 5,
  DURABILITY = 0,
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Quiver = class('Quiver', ItemBase)

Quiver.static = {
  FULL_NAME = 'quiver',
  WEIGHT = 4,
  DURABILITY = 0,
  CATEGORY = 'military',
}

return {Magazine, Shell, Clip, Quiver}