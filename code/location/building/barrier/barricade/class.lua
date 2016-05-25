local class = require('code.libs.middleclass')
local dice = require('code.libs.rl-dice.dice')
local barrier = require('code.location.building.barrier.class')

local barricade = class('barricade', barrier)
local default_hp, max_hp = 0, 63

function barricade:initialize(type)
  barrier.initialize(self) 
  self.hp = default_hp
end  

barricade.max_hp = max_hp -- what the fuck is this for?!?

function barricade:isDestroyed() return self.hp == 0 end

--[[
--  BARRICADE LEVELS
local empty, loosely, light, strong = 1, 4, 8, 12
local moderate, very_strong, heavily, extremelly_heavily = 16, 20, 24, 28
 
local cade = {
  overcrowd = {10, 18, 24, 28},
    penalty = { 0, -1, -2, -3},
}

-- BARRICADE LEVELS (by size)
local cade_sizes = {1, 2, 3, 4}

local function roomForCade(barricade, obj_size)
  -- do max barricade_hp cade check?

  for LV=1, cade.overcrowd do
    if barricade <= cade.overcrowd[LV] then return LV <= obj_size end
  end
end

local function roomPenalty(barricade)
  for i=1, cade.overcrowd do
    if barricade <=  cade.overcrowd[i] then return cade.penalty[i] end
  end  
end

--function barrier:barricade(obj)
  local barricade = self:getBarricade()
  local size = obj:getSize()  
  if roomForCade(barricade, size) then
    size = size -  roomPenalty(barricade)  
    self:updateCade(size)
  else
    error('cade problem?')
  end
end
--]]

return barricade