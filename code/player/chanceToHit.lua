local skill_attack_bonus = require('code.player.skills.attack_bonus')

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