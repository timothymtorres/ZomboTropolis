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
Magazine.ap = {cost = 3, modifier = {guns = -2, handguns = -1}}

-------------------------------------------------------------------

local Shell = class('Shell', ItemBase)

Shell.FULL_NAME = 'shotgun shell'
Shell.WEIGHT = 2
Shell.DURABILITY = 0
Shell.CATEGORY = 'military'
Shell.ap = {cost = 2, modifier = {guns = -1, shotguns = -1}}

-------------------------------------------------------------------

local Clip = class('Clip', ItemBase)

Clip.FULL_NAME = 'rifle clip'
Clip.WEIGHT = 5
Clip.DURABILITY = 0
Clip.CATEGORY = 'military'
Clip.ap = {cost = 4, modifier = {guns = -3,   rifles = -1}}

-------------------------------------------------------------------

local Quiver = class('Quiver', ItemBase)

Quiver.FULL_NAME = 'quiver'
Quiver.WEIGHT = 4
Quiver.DURABILITY = 0
Quiver.CATEGORY = 'military'
Quiver.ap = {cost = 4, modifier = {archery = -3,     bows = -1}}

--[[ 
**RELOADING**
assualt rifle - ? ap (3 bursts)         [10 ap, 8ap,  5ap]
magnum        - ? ap (6 shots)          [5 ap,  4ap,  2ap]
pistol        - ? ap (14 shots)         [5 ap,  4ap,  2ap]
shotgun       - ? ap (2 shots)          [3 ap,  2ap, .5ap]
bow           - ? ap (8 shots [quiver]) [8 ap,  6ap,  3ap]  
speed_loader =  {cost=3, modifier={guns = -2, handguns = -1},},  
--]]        

return {Magazine, Shell, Clip, Quiver}