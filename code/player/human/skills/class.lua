local class = require('code.libs.middleclass')
local bit = require('plugin.bit')
local band, bor, bxor, bnot, rshift = bit.band, bit.bor, bit.bxor, bit.bnot, bit.rshift
local flags = require('code.player.skills.flags')
local s_list = require('code.player.skills.list')

local skills = class('skills')

function skills:initialize(player)
  self.flags = {}
  local mob_type = player:getMobType()
  for _, category in pairs(s_list.order[mob_type].category) do self.flags[category] = 0 end
end

function skills:getFlags(category) return self.flags[category] end

local function countSetFlags(bits)  -- count the number of set bits
  local count = 0
  while bits > 0 do
    count = count + band(bits, 1)
    bits = rshift(bits, 1)
  end
--print('total skill count ='..count)  
  return count
end

function skills:countFlags(category)
  local count = 0
  if category == 'skills' then -- seperates skill bitflags from classes (ie. isolate skill bitflags)  
    for flag_category, flags in pairs(self.flags) do
      if flag_category ~= 'classes' then 
        count = count + countSetFlags(flags) 
      end
    end
  elseif category == 'classes' then -- seperates class bitflags from skills  (ie. isolate class bitflags)  
    count = countSetFlags(self.flags.classes)
  else -- count all skills in specific class (ie. isolate [category] bitflags) 
    count = countSetFlags(self.flags[category])
  end
  return count
end

local class_cost = {100, 300, 600, 1000}

function skills:getCost(mode)
  local cost, total_flags
  if mode == 'skills' then  
    total_flags = self:countFlags('skills')
    cost = (.2*(total_flags)^2 + .25*(total_flags) + 50)
  elseif mode == 'classes' then
    total_flags = self:countFlags('classes')
    cost = class_cost[total_flags+1]
  end
  return math.floor(cost + 0.5)
end

-- class prices, 100, 300, 600, 1000
-- skill buy formula (y = .2*(x)^2 + .25*(x) + 50)
function skills:buy(player, skill)
  local player_mob_type = player:getMobType()
  local xp = player:getStat('xp')
  
  local class = s_list.isClass(skill)  
  local cost = (class and self:getCost('classes') ) or self:getCost('skills')  
  local required_flags = s_list.getRequiredFlags(skill)
  local skill_mob_type = s_list.getMobType(skill)
print('[skills:buy]', 'player.xp='..xp, 'skill['..skill..'] cost='..cost)  
--print('required_flags = ', required_flags)  
  
  -- should return error msgs?
  assert(xp >= cost, 'Not enough xp')
  assert(skill_mob_type == player_mob_type, 'Player mob type does not match skill')
  assert(player:isStanding(), 'Player must revive first')
  assert(not player.skills:check(skill), 'Already have skill')  
  
  for category, flags in pairs(required_flags) do
    assert(flags == 0 or player.skills:checkFlag(category, flags), 'Missing required skills')
  end
  
  player:updateStat('xp', (-1)*cost)  
  player.skills:add(skill)  
end

local function lookupFlags(skills)
  local array = {}
  for i, skill in ipairs(skills) do 
--print('[player/skills/class lookupFlags] - '..skill, flags[skill])
--if not flags[skill] then return error('Skill does not exist') end    
    array[i] = flags[skill] end
  return array
end

local function combineFlags(requirements)
  local list = lookupFlags(requirements)
  return bor(unpack(list)) 
end

function skills:checkFlag(category, flag) return 
--print('required flag = '..flag, 'current flags = '..self:getFlags())  
  band(self:getFlags(category), flag) == flag end

function skills:check(skill) return self:checkFlag(s_list.getCategory(skill), flags[skill]) end

function skills:add(skill) 
  local category = s_list.getCategory(skill)
  self.flags[category] = bor(self.flags[category], flags[skill]) 
end

-- no removing skills for this game...
-- function skills:remove(skill) self.flags = band(self.flags, bnot(flags[skill])) end

return skills