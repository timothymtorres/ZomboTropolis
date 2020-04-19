local class = require('code.libs.middleclass')
local Item = require('code.item.item')

local Ammo_Pistol = class('Ammo_Pistol', Item)
Ammo_Pistol.ap = {cost = 1}

-------------------------------------------------------------------

local Ammo_Shotgun = class('Ammo_Shotgun', Item)
Ammo_Shotgun.ap = {cost = 1}

-------------------------------------------------------------------

local Ammo_Magnum = class('Ammo_Magnum', Item)
Ammo_Magnum.ap = {cost = 1}

-------------------------------------------------------------------

local Ammo_SMG = class('Ammo_SMG', Item)
Ammo_SMG.ap = {cost = 1}

-------------------------------------------------------------------

local Ammo_Bow = class('Ammo_Bow', Item)
Ammo_Bow.ap = {cost = 1}

return {Ammo_Pistol, Ammo_Shotgun, Ammo_Magnum, Ammo_SMG, Ammo_Bow}