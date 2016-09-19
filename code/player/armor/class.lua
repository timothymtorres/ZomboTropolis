local dice = require('code.libs.rl-dice.dice')
local class = require('code.libs.middleclass')

local armor = class('armor')

function armor:initialize(player) 
  self.player = player
end

function armor:passDurabilityCheck(degrade_chance) return dice:roll(self.durability) > degrade_chance end

function armor:getProtection(damage_type) return self.protection[damage_type] or 0 end

function armor:isPresent() return self.protection and true or false end

return armor