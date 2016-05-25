local class = require('libs/middleclass')
local bit = require('bit')
local band, bor, bxor, bnot = bit.band, bit.bor, bit.bxor, bit.bnot
local flags = require('player/skills/flags')
local s_list = require('player/skills/list')

local skills = class('skills')
local default_slots = 12

function skills:initialize() 
  self.flags = 0
  self.slots = default_slots
end

function skills:getFlags() return self.flags end

function skills:isSlotAvailable() return self.slots > 0 end

function skills:updateSlots(num) self.slots = self.slots + num end

-- class prices, 100, 200, 350, 550
-- skill buy formula (y = .2*(x)^2 + .25*(x) + 50)
function skills:buy(player, skill)
  local player_mob_type = player:getMobType()
  local slot_open = player.skills:isSlotAvailable()
  local xp = player:getXP()
  
  local cost = s_list:getCost(skill)  
  local required_flags = s_list:getRequiredFlags(skill)
  local skill_mob_type = s_list:getMobType(skill)
  local innate = s_list:isInnate(skill)
  local memory = s_list:getMemory(skill)
--print('[skills:buy]', 'player.xp='..xp, 'skill['..skill..'] cost='..cost)  
  
  -- should return error msgs?
  if xp < cost then return error('not enough xp') end
  if skill_mob_type ~= player_mob_type then return false end
  if not player:isStanding() then return false end
  
--[[  
if required_flags ~= 0 then  
print('required_flags='..required_flags) 
print('skills:check - ', player.skills:check(required_flags))
end
--]]

  if required_flags ~= 0 and not player.skills:check(required_flags) then return false end


  if not innate and not slot_open then return false end
  
  player:updateXP( (-1)*cost)
  
  if innate then
    player.skills:add(skill)
    if memory then player.skills:updateSlots(memory) end      
  else   
    player.skills:add(skill)  
    player.skills:updateSlots(-1)
  end
end

local function lookupFlags(skills)
  local array = {}
  for i, skill in ipairs(skills) do 
print('[player/skills/class lookupFlags] - '..skill, flags[skill])
    if not flags[skill] then return error('Skill does not exist') end    
    array[i] = flags[skill] end
  return array
end

local function combineFlags(requirements)
  local list = lookupFlags(requirements)
  return bor(unpack(list)) 
end

function skills:check(skill_flag)  
--print('self.flags='..self.flags, 'skill_flag='..skill_flag)
  return band(self:getFlags(), skill_flag) > 0 end

 function skills:add(skill) 
--print('self.flags - ', self.flags,'flags[skill]', flags[skill])
     self.flags = bor(self.flags, flags[skill]) end

function skills:remove(skill) self.flags = band(self.flags, bnot(flags[skill])) end

return skills