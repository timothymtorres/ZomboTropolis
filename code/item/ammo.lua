local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')
local dice =           require('code.libs.dice')
 
--ammo[item].durability = 0  -- all ammo is single use??? Or nah?

local Magazine = class('Magazine', ItemBase)

Magazine.FULL_NAME = 'pistol magazine'
Magazine.WEIGHT = 3
Magazine.DURABILITY = 0
Magazine.CATEGORY = 'military'

-------------------------------------------------------------------

local Shell = class('Shell', ItemBase)

Shell.FULL_NAME = 'shotgun shell'
Shell.WEIGHT = 2
Shell.DURABILITY = 0
Shell.CATEGORY = 'military'

-------------------------------------------------------------------

local Clip = class('Clip', ItemBase)

Clip.FULL_NAME = 'rifle clip'
Clip.WEIGHT = 5
Clip.DURABILITY = 0
Clip.CATEGORY = 'military'

-------------------------------------------------------------------

local Quiver = class('Quiver', ItemBase)

Quiver.FULL_NAME = 'quiver'
Quiver.WEIGHT = 4
Quiver.DURABILITY = 0
Quiver.CATEGORY = 'military'

return {Magazine, Shell, Clip, Quiver}