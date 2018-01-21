local skill_attack_bonus = { 
  human = {
    melee = {melee=0.05, melee_adv=0.10},
    ranged = {ranged=0.10, ranged_adv=0.15,},
    
  -- MELEE WEAPONS
    brute = {blunt=0.10, blunt_adv=0.15},
    cut = {blade=0.10, blade_adv=0.15},  
    hand = {martial_arts=0.10}, --, martial_arts_adv=0.15},  --  H2H WEAPON  
    
  -- RANGED WEAPONS
    light_guns = {sidearm=0.15},
    heavy_guns = {primary=0.15},
    --bows = {archery=0.10, archery_adv=0.15},
    explosives = {pyrotech=0.05, pyrotech_adv=0.10},
  },
  zombie = {
    melee = {muscle_stimulus=0.05},
    --ranged = {},
    
    arm = {hand_stimulus=0.10, claw=0.10, claw_adv=0.15},
    teeth = {head_stimulus=0.10, bite=0.10, bite_adv=0.15},
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
    if player.skills:check(skill) then skill_bonus = skill_bonus + skill_attack_bonus[mob_type][attack_style][skill] end
  end
  
  -- skill bonus for weapon categories
  for _, weapon_type in ipairs(weapon_groups) do
    for skill in pairs(skill_attack_bonus[mob_type][weapon_type]) do
      if player.skills:check(skill) then skill_bonus = skill_bonus + skill_attack_bonus[mob_type][weapon_type][skill] end
    end
  end

  local attack_chance = base_chance + skill_bonus + condition_bonus

  -- if attacking building or equipment (from the outside) there is a severe penalty, the to-hit chance is halved
  if target:getClassName() ~= 'player' and player:isStaged('outside') then attack_chance = attack_chance*0.5 end 

  return attack_chance
end

return chanceToHit