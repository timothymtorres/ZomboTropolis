-- 64 skills max  (4 are classes/4 are slots)

-- 56 skills 5 cataegories (16 general skills, 10 in each skill tree [4x10 = 40] )
--start,300,350,400,500xp
--  12, 14, 12,  10,  8  

local skill_flags = {  
  military =             1,
  medical =              2,
  science =              4,
  engineering =          8,  
  
  brute =                1,
  sentient =             2,
  hunter =               4,
  hive =                 8,
 
  slot26 =              16,
  slot38 =              32,
  slot48 =              64,
  slot56 =             128,
}  -- The numbers start to get REALLY big soooo time to *2 our bitflags

--[[
--- HUMAN
--]]

-- General
skill_flags.roof_travel = skill_flags.slot56*2
skill_flags.melee = skill_flags.roof_travel*2
skill_flags.stabbing = skill_flags.melee*2
skill_flags.swinging = skill_flags.stabbing*2
skill_flags.ranged = skill_flags.swinging*2

-- Military
skill_flags.melee_adv = skill_flags.ranged*2
skill_flags.stabbing_adv = skill_flags.melee_adv*2
skill_flags.swinging_adv = skill_flags.stabbing_adv*2
skill_flags.ranged_adv = skill_flags.swinging_adv*2
skill_flags.weapon_expert = skill_flags.ranged_adv*2

-- Medical
skill_flags.diagnosis = skill_flags.weapon_expert*2
skill_flags.diagnosis_adv = skill_flags.diagnosis*2
skill_flags.first_aid = skill_flags.diagnosis_adv*2
skill_flags.surgery = skill_flags.first_aid*2

-- Science
skill_flags.lab_tech = skill_flags.surgery*2
skill_flags.researcher = skill_flags.lab_tech*2

-- Engineering
skill_flags.repairs = skill_flags.researcher*2
skill_flags.repairs_adv = skill_flags.repairs*2

--[[
--- ZOMBIE
--]]

-- General

skill_flags.groan = skill_flags.slot56*2

-- Brute

-- Hunter

-- Sentient

-- Hive

--[[
print()
print('SKILL_FLAGS LIST')
print()
for k,v in pairs(skill_flags) do print(k,v) end
--]]

return skill_flags