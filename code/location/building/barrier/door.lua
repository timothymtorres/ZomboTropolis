local class = require('code.libs.middleclass')
local barrier = require('code.location.building.barrier.class')

local Door = class('Door', barrier)  
local default_hp, max_hp = 3, 3

local door_desc = {[0] = 'destroyed', [1] = 'smashed', [2] = 'dented', [3] = 'undamaged'}

function Door:initialize()
  barrier.initialize(self)
  
  self.hp = default_hp
  self.is_open = false
  
  self.hp_desc = door_desc[default_hp]
 end 
 
 Door.max_hp = max_hp

function Door:updateDesc() self.hp_desc = door_desc[self.hp] end

function Door:getDesc() return self.hp_desc end

function Door:repair() self:updateHP(3) end

function Door:toggle() self.is_open = not self.is_open end

function Door:isDestroyed() return self.hp == 0 end

function Door:isOpen() return self.is_open end

return Door