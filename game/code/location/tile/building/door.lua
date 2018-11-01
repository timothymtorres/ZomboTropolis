local class = require('code.libs.middleclass')
local Barrier = require('code.location.tile.building.barrier')

local Door = class('Door', Barrier)  
local DEFAULT_HP, MAX_HP = 3, 3

function Door:initialize()
  Barrier.initialize(self)
  
  self.hp = DEFAULT_HP
  self.is_open = false
 end 

function Door:repair() self:updateHP(3) end

function Door:toggle() self.is_open = not self.is_open end

function Door:isDamaged() return self.hp ~= MAX_HP end

function Door:isOpen() return self.is_open end

return Door