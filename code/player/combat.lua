local chanceToHit = require('code.item.weapon.chanceToHit')
local dice = require('code.libs.dice')

local function combat(player, target, weapon)
  local attack = chanceToHit(player, target, weapon) >= math.random()
  local damage, critical
  
  if attack then -- successful!
    if target:getClassName() == 'player' then
      local weapon_dice = weapon:getDice(player)      
      damage = dice.roll(weapon_dice)        
      critical = weapon:getCrit() >= math.random()
      if critical then damage = damage*2 end
    elseif target:getClassName() == 'equipment' then
      damage = weapon:getObjectDamage('equipment')      
    else -- target == 'building'
      damage = weapon:getObjectDamage(target:getBarrier() )      
    end 
  end
  
  return attack, damage, critical
end

return combat