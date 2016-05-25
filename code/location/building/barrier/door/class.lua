local class = require('code.libs.middleclass')
local barrier = require('code.location.building.barrier.class')

local door = class('door', barrier)  
local default_hp, max_hp = 3, 3

function door:initialize()
  barrier.initialize(self)
  
  self.hp = default_hp
  self.is_open = false
 end 
 
 door.max_hp = max_hp

--  DOOR LEVELS
local destroyed, broken, smashed, normal = 0, 1, 2, 3

function door:repair() self:updateHP(3) end

function door:toggle() self.is_closed = not self.is_open end

function door:isDestroyed() return self.hp == 0 end

function door:isOpen() return self.is_open end

return door