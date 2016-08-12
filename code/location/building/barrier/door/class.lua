local class = require('code.libs.middleclass')
local barrier = require('code.location.building.barrier.class')

local door = class('door', barrier)  
local default_hp, max_hp = 3, 3

local door_desc = {[0] = 'destroyed', [1] = 'broken', [2] = 'smashed', [3] = 'normal'}

function door:initialize()
  barrier.initialize(self)
  
  self.hp = default_hp
  self.is_open = false
  
  self.hp_desc = door_desc[default_hp]
 end 
 
 door.max_hp = max_hp

function door:updateDesc() self.hp_desc = door_desc[self.hp] end

function door:getDesc() return door_desc[self.hp] end

function door:repair() self:updateHP(3) end

function door:toggle() self.is_open = not self.is_open end

function door:isDestroyed() return self.hp == 0 end

function door:isOpen() return self.is_open end

return door