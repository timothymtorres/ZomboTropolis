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

Crowbar.static = {
  FULL_NAME = 'crowbar',
  WEIGHT = 8,
  DURABILITY = 25,  
  MASTER_SKILL = 'smacking',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Bat = class('Bat', ItemBase)

Bat.static = {
  FULL_NAME = 'baseball bat',
  WEIGHT = 9,
  DURABILITY = 15,  
  MASTER_SKILL = 'smacking',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Sledge = class('Sledge', ItemBase)

Sledge.static = {
  FULL_NAME = 'sledgehammer',
  WEIGHT = 25,
  DURABILITY = 20,  
  MASTER_SKILL = 'smashing',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

--[[
---  BLADE
--]]

-------------------------------------------------------------------

local Knife = class('Knife', ItemBase)

Knife.static = {
  FULL_NAME = 'knife',
  WEIGHT = 3,
  DURABILITY = 10,  
  MASTER_SKILL = 'slicing',
  CATEGORY = 'military',
}

-------------------------------------------------------------------

local Katanna = class('Katanna', ItemBase)

Katanna.static = {
  FULL_NAME = 'katanna',
  WEIGHT = 7,
  DURABILITY = 15,  
  MASTER_SKILL = 'chopping',
  CATEGORY = 'military',
}

return {Crowbar, Bat, Sledge, Knife, Katanna}