local class =          require('code.libs.middleclass')
local ItemBase =       require('code.item.item_base')
local broadcastEvent = require('code.server.event')
string.replace =       require('code.libs.replace')

-- need to add designated_weapon var to items?  Or do this via mixins?
-- weaponry[item].designated_weapon = true 

-------------------------------------------------------------------

--[[
---  BRUTE
--]]

local Crowbar = class('Crowbar', ItemBase)

Crowbar.FULL_NAME = 'crowbar'
Crowbar.WEIGHT = 8
Crowbar.DURABILITY = 25
Crowbar.MASTER_SKILL = 'smacking'
Crowbar.CATEGORY = 'military'

-------------------------------------------------------------------

local Bat = class('Bat', ItemBase)

Bat.FULL_NAME = 'baseball bat'
Bat.WEIGHT = 9
Bat.DURABILITY = 15
Bat.MASTER_SKILL = 'smacking'
Bat.CATEGORY = 'military'

-------------------------------------------------------------------

local Sledge = class('Sledge', ItemBase)

Sledge.FULL_NAME = 'sledgehammer'
Sledge.WEIGHT = 25
Sledge.DURABILITY = 20
Sledge.MASTER_SKILL = 'smashing'
Sledge.CATEGORY = 'military'

-------------------------------------------------------------------

--[[
---  BLADE
--]]

-------------------------------------------------------------------

local Knife = class('Knife', ItemBase)

Knife.FULL_NAME = 'knife'
Knife.WEIGHT = 3
Knife.DURABILITY = 10
Knife.MASTER_SKILL = 'slicing'
Knife.CATEGORY = 'military'

-------------------------------------------------------------------

local Katanna = class('Katanna', ItemBase)

Katanna.FULL_NAME = 'katanna'
Katanna.WEIGHT = 7
Katanna.DURABILITY = 15
Katanna.MASTER_SKILL = 'chopping'
Katanna.CATEGORY = 'military'

return {Crowbar, Bat, Sledge, Knife, Katanna}