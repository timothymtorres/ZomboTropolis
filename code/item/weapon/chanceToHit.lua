local skill_attack_bonus = { 
  --group_catagetory = {skill_name1=attack_bonus, skill_name2=attack_bonus, etc.}
  human = {
    melee = {melee=0.05, melee_adv=0.10},
    ranged = {ranged=0.05, ranged_adv=0.10,},
    
  -- MELEE WEAPONS
    brute = {swinging=0.10},
    light_brute = {smacking=0.15},
    heavy_brute = {smashing=0.15},
  
    blade = {cutting=0.10},  
    light_blade = {slicing=0.15},
    heavy_blade = {chopping=0.15},
    
    hand = {martial_arts=0.10, martial_arts_adv=0.15},  --  H2H WEAPON  
    
  -- RANGED WEAPONS
    guns = {shooting=0.10},
    light_guns = {light_guns=0.15},
    heavy_guns = {heavy_guns=0.15},
    
    bows = {archery=0.10, archery_adv=0.15},
    
  },
  zombie = {
    melee = {muscle_stimulus=0.05},
    ranged = {},
    
    arm = {hand_stimulus=0.10, claw=0.10, claw_adv=0.15},
    teeth = {head_stimulus=0.10, bite=0.10, bite_adv=0.15},
    acid = {acid=0.05, acid_adv=0.05},
    stinger = {venom=0.05, venom_adv=0.10},
  },
}

local function chanceToHit(player, target, weapon)
  if weapon:isHarmless() then return weapon:getAccuracy() end  -- no need to do a bunch of skill checks for harmless weapons
    
  local mob_type = player:getMobType()
  
  local weapon_groups = weapon:getGroup()
  local attack_style = weapon:getStyle()
  local base_chance, condition_bonus = weapon:getAccuracy(player, target)
  local damage_type = weapon:getDamageType()
  
  local skill_bonus = 0

  -- skill bonus for melee/ranged attack style
  for skill in pairs(skill_attack_bonus[mob_type][attack_style]) do
    if player.skills:check(skill) then skill_bonus = skill_bonus + skill_attack_bonus[mob_type][attack_style][skill] 
--print('Bonus Attack Style Acquired - ['..skill..'] = '..skill_attack_bonus[mob_type][attack_style][skill])  
    end
  end
  
--print('attack style skill bonus = '..skill_bonus)  
  
  -- skill bonus for weapon categories
  for _, weapon_type in ipairs(weapon_groups) do
--print('combat - weapon_type', weapon_type)
    for skill in pairs(skill_attack_bonus[mob_type][weapon_type]) do
--print(skill, flags[skill])
      if player.skills:check(skill) then skill_bonus = skill_bonus + skill_attack_bonus[mob_type][weapon_type][skill] 
--print('Bonus Weapon Group Acquired - ['..skill..'] = '..skill_attack_bonus[mob_type][weapon_type][skill])          
      end
    end
  end
  
--print('weapon category skill bonus = '..skill_bonus)   
  

  
  local attack_chance = base_chance + skill_bonus + condition_bonus
--print('attack_chance='..attack_chance, 'skill bonus='..skill_bonus..'/condition bonus='..condition_bonus..'/base_chance='..base_chance)
--print('dice.chance('..attack_chance..') =', dice.chance(attack_chance))

  -- if attacking building or equipment (from the outside) there is a severe penalty, the to-hit chance is halved
  if target:getClassName() ~= 'player' and player:isStaged('outside') then attack_chance = attack_chance*0.5 end 

  return attack_chance
end

return chanceToHit