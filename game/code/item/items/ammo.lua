local class = require('code.libs.middleclass')
local Item = require('code.item.item')

local Ammo_Pistol = class('Ammo_Pistol', Item)

Ammo_Pistol.FULL_NAME = 'box of pistol ammo'
Ammo_Pistol.WEIGHT = 3
Ammo_Pistol.DURABILITY = 0
Ammo_Pistol.CATEGORY = 'military'
Ammo_Pistol.ap = {cost = 3, modifier = {guns = -2, handguns = -1}}

-------------------------------------------------------------------

local Ammo_Shotgun = class('Ammo_Shotgun', Item)

Ammo_Shotgun.FULL_NAME = 'box of shotgun ammo'
Ammo_Shotgun.WEIGHT = 2
Ammo_Shotgun.DURABILITY = 0
Ammo_Shotgun.CATEGORY = 'military'
Ammo_Shotgun.ap = {cost = 2, modifier = {guns = -1, shotguns = -1}}

-------------------------------------------------------------------

local Ammo_Magnum = class('Ammo_Magnum', Item)

Ammo_Magnum.FULL_NAME = 'box of magnum ammo'
Ammo_Magnum.WEIGHT = 2
Ammo_Magnum.DURABILITY = 0
Ammo_Magnum.CATEGORY = 'military'
Ammo_Magnum.ap = {cost = 2, modifier = {guns = -1, shotguns = -1}}

-------------------------------------------------------------------

local Ammo_SMG = class('Ammo_SMG', Item)

Ammo_SMG.FULL_NAME = 'box of SMG ammo'
Ammo_SMG.WEIGHT = 5
Ammo_SMG.DURABILITY = 0
Ammo_SMG.CATEGORY = 'military'
Ammo_SMG.ap = {cost = 4, modifier = {guns = -3,   rifles = -1}}

-------------------------------------------------------------------

local Ammo_Bow = class('Ammo_Bow', Item)

Ammo_Bow.FULL_NAME = 'quiver of arrows'
Ammo_Bow.WEIGHT = 4
Ammo_Bow.DURABILITY = 0
Ammo_Bow.CATEGORY = 'military'
Ammo_Bow.ap = {cost = 4, modifier = {archery = -3,     bows = -1}}

--[[ 
**RELOADING**
assualt rifle - ? ap (3 bursts)         [10 ap, 8ap,  5ap]
magnum        - ? ap (6 shots)          [5 ap,  4ap,  2ap]
pistol        - ? ap (14 shots)         [5 ap,  4ap,  2ap]
shotgun       - ? ap (2 shots)          [3 ap,  2ap, .5ap]
bow           - ? ap (8 shots [quiver]) [8 ap,  6ap,  3ap]  
speed_loader =  {cost=3, modifier={guns = -2, handguns = -1},},  
--]]        

return {Ammo_Pistol, Ammo_Shotgun, Ammo_Magnum, Ammo_SMG, Ammo_Bow}