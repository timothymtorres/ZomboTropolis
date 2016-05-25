local skill_flags = require('player/skills/flags')
local skill_list = {}
local bit = require('bit')
local band, bor, bxor, bnot = bit.band, bit.bor, bit.bxor, bit.bnot

--[[
  skill = {name='string', desc='string', innate=true/nil, requires={'skill_name1', 'skill_name2', etc.}/nil}
--]]

local skill_info = {
  zombie = {
      general = {},
      brute = {},
      sentient = {},
      hunter = {},
      hive = {},
  },
  human = {
    general = {
      engineering =    {name='engineering',     desc='Unlock Engineering skills', innate=true,},
      military =       {name='military',        desc='Unlock Military skills', innate=true,},
      science =        {name='science',         desc='Unlock Science skills', innate=true,},
      medical =        {name='medical',         desc='Unlock Medical skills', innate=true,},     
      
      melee =          {name='melee',     desc='Melee weapons  +5% to-hit'},
      cutting =        {name='cutting',         desc='Blade weapons +10% to-hit',      requires={'melee'},},   
      swinging =       {name='swinging',        desc='Blunt weapons +10% to-hit',      requires={'melee'},},
      smacking =       {name='smacking',        desc='Light blunt weapons +15 to-hit', requires={'swinging'},},
      martial_arts =   {name='martial arts',    desc='Hand-to-hand combat +15 to-hit', requires={'melee'}, },
      ranged =         {name='ranged', desc='Ranged weapons +5% to-hit'},
      roof_travel =    {name='roof travel',      desc='Travel through buildings'},
      hp_bonus =       {name='hp bonus',          desc='Bonus +10 hp',},
      ip_bonus =       {name='ip bonus',       desc='Bonus +10 ip', requires={'hp_bonus'},},  
      looting =        {name='looting', desc='bonus for searching',},
    },

    military = {
      ranged_adv =     {name='ranged advanced',    desc='Ranged weapons +10% to-hit'},
        guns =           {},
          shotguns =     {},
          handguns =     {},
          rifles =       {},
        archery =        {},
          bows  =        {},
      melee_adv =      {name='melee advanced',   desc='Melee weapons +10% to-hit'},
        chopping =       {},
        slicing =        {},
        smashing =       {},
        --stabbing_adv = {name='slice & dice',    desc='Blade weapons +15% to-hit', requires={'melee_adv'},},
        --swinging_adv = {name='melee master',    desc='Blunt weapons +15% to-hit', requires={'melee_adv'},},
      explosives =      {name='explosives',      desc='Scorch weapons +10% to-hit'},  
    },
    medical = {
      diagnosis =      {name='check up',        desc='Determine VAGUE health status'},
      diagnosis_adv =  {name='diagnosis',       desc='Determine PRECISE health status', requires={'diagnosis'},},
      first_aid =      {name='first aid',       desc='First Aid Kits give +10 hp',},
      surgery =        {name='surgery',         desc='First Aid Kits give +15 hp in powered hospital', requires={'first_aid'},},
    },
    science = {
      lab_tech =       {name='lab tech',        desc='Gain ability to use science equipment',},
      researcher =     {name='researcher',      desc='Gain ability to tag zombies and track via terminals',},
      computer_tech =  {},  -- terminals installed/repaired/use at less ap
    },
    engineering = {
      construction = {},
        repairs =        {name='basic repairs',   desc='Gain ability to repair equipment',},
          repairs_adv=     {name='advanced repairs',desc='Gain ability to repair ruined buildings',}, 
          renovate = {} -- repair ruins
        barricade = {},  -- barricade past very strongly?
          barricade_adv=   {name='pack rat',        desc='Build better barricades',},  -- +1 to all barricades
          reinforce =      {},  -- extend max barricade limit more easier          
      tech = {},  
        power_tech =     {}, -- generators installed/repaired at less ap
        radio_tech =     {},
        computer_tech =  {},
        
      reserve =  {} -- toolbox durability increased        
    },
  },
}

-- 64 skills max  (4 are classes)
-- 60 skills 5 cataegories (12 general skills, 12 in each skill tree)

--[[
print()
print('SKILL_FLAGS LIST')
print()
for k,v in pairs(skill_flags) do print(k,v) end
--]]

local function lookupFlags(skills)
  local array = {}
  for i, skill in ipairs(skills) do array[i] = skill_flags[skill] end
  return array
end

local function combineFlags(requirements)
  local list = lookupFlags(requirements)
  return bor(unpack(list)) 
end

local function fillList(list)
  for mob_type in pairs(skill_info) do 
    for skill_tree in pairs(skill_info[mob_type]) do 
      for skill, data in pairs(skill_info[mob_type][skill_tree]) do 
        list[skill] = data
        list[skill].mob_type = mob_type
        list[skill].category = skill_tree
          
        list[skill].requires = list[skill].requires or {}               
        list[skill].requires[#list[skill].requires+1] = (skill_tree ~= 'general' and skill_tree) or nil
--print('skill - '..skill, 'skill_tree - '..skill_tree)
        local requirements = list[skill].requires
        list[skill].required_flags = next(requirements) and combineFlags(requirements) or 0  
--print('skill - '..skill, 'flags - '..list[skill].flags)
      end 
    end
  end
  return list
end

do  -- combine zombie/human skills into one list
  skill_list = fillList(skill_list)
end

function skill_list:getCost(skill) return skill_list[skill].cost end

function skill_list:getRequirement(skill) return skill_list[skill].requires end

function skill_list:getRequiredFlags(skill) return skill_list[skill].required_flags end

function skill_list:getMobType(skill) return skill_list[skill].mob_type end

function skill_list:getMemory(skill) return skill_list[skill].memory end

function skill_list:isInnate(skill) return skill_list[skill].innate end

function skill_list:isMemory(skill) return skill_list[skill].memory and true or false end

return skill_list