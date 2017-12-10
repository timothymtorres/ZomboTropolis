local dice =        require('code.libs.dice')

local IsWeapon = {}

--[[
  {
    full_name = 'insert name'
    attack_style = melee/ranged
    damage_type = bullet/pierce/blunt/scorch
    group = {
      organic (arm/teeth/stomach)  
      melee (brute/blade)  
      firearms (gun/handgun/shotgun/rifle)  
      archery (bow/crossbow)
      misc. (special)
    }
    dice = '?d?'
    accuracy = 0.00 (base chance to hit)
    critical = 0.00 (base chance for crit)
    
    *if gun/bow*
    
    max_ammo = num
    reload_amount = num
    
    *optional*
    
    organic = human/zombie/nil (results in default weapon choice, since weapon is attached to body)
    object_damage = {barricade=1/2/nil, door=1/2/nil, equipment=1/2/nil} /nil
    master_skill = skill_name/nil (designated skill that signals mastery)
    one_use = true/nil (is disposed of after one use)
    ^^^^ if weapon is ranged immediately after firing it's used
    ^^^^ if weapon is melee then when a hit is landed it's used 
    no_damage = true/nil (does not cause damage)
    condition_effect = poison/infect/burn/confuse/blind/nil
    skill_required = skill_name/nil  (need a skill to use this weapon, mostly for special zombie attacks)
    fuel_amount = {num}/nil
    combustion_source = true/false/nil (can this weapon ignite a fire)
  } 
--]]

-- WEAPON CONDITION MODIFIERS (blunt = damage range, blade = damage bonus, bullet = to-hit-accuracy, scorch = damage rolls)

function IsWeapon:isOrganic(mob_type) return (mob_type and self.weapon.ORGANIC == mob_type) or self.weapon.ORGANIC or false end

function IsWeapon:isHarmless() return self.weapon.NO_DAMAGE or false end

--function IsWeapon:isSkillRequired() return (self.weapon.SKILL_REQUIRED and true) or false end

--function IsWeapon:isCombustionSource() return self.combustion_source or false end

function IsWeapon:hasConditionEffect(player)
  if self:getClassName() == 'claw' and not player.skills:check('grapple') then 
    return false -- if attacking with claws and missing grapple skill then no condition effect  
  elseif self:getClassName() == 'bite' and not player.skills:check('infection') then
    return false -- if attacking with bite and missing infection skill then no condition effect
  end
  
  return (self.condition_effect and true) or false 
end

--function IsWeapon:getSkillRequired() return self.weapon.SKILL_REQUIRED end

--function IsWeapon:getFuelAmount() return self.fuel_amount end

function IsWeapon:getCrit() return self.weapon.CRITICAL end

function IsWeapon:getStyle() return self.weapon.ATTACK_STYLE end
  
function IsWeapon:getGroup() return self.weapon.GROUP end 
 
function IsWeapon:getDamageType() return self.weapon.DAMAGE_TYPE end 

--function IsWeapon:getObjectDamage(type) return (self.object_damage and self.object_damage[type]) or false end

--function IsWeapon:getWeaponID() return self.weapon_ID end

local modifier = {
  power_claw =   0.15,                      -- to-hit% bonus (for equipment and buildings)    
  zombie_melee={-0.05,  0.00, 0.05, 0.10},  -- to-hit%
  projectile = {-0.10, -0.05, 0.00, 0.05},  -- to-hit%
   
       blunt = {-2, -1, 0, 1},              -- range
      pierce = {-2, -1, 0, 1},              -- bonus
      scorch = {-2, -1, 0, 1},              -- dice               
}

function IsWeapon:getAccuracy(player, target)
  local accuracy_bonus
  
  if player:isMobType('zombie') then
    if self:getStyle() == 'melee' then
      if player:isTangledTogether(target) then
        accuracy_bonus = modifier.zombie_melee[3] -- no need for modifier.zombie_melee[3], can't we just use 0.05% directly?

        -- future feature:  think about adding multiple tangledTogether attack bonus for every zombie grappling target 
        
      elseif target:getClassName() ~= 'player' then -- equipment or building
        if player.skills:check('power_claw') then accuracy_bonus = modifier.power_claw end
      end
      --if maimed condition then accuracy_bonus = modifier.zombie_melee[1]
    end
  else  -- is human, thus weapon is item
    accuracy_bonus = self.weapon.DAMAGE_TYPE == 'bullet' and modifier.projectile[self.condition]
  end
  
  -- accuracy bonus ONLY applies to ranged human weapons and zombie melee attacks  
  accuracy_bonus = accuracy_bonus or 0
  return self.weapon.ACCURACY, accuracy_bonus
end

local organic_modifier = {
  claw = {
    dice={'1d4', '2d4'}, 
    included_skills={'claw', 'dual_claw'},
  },
  bite = {
    dice={'1d5+1', '1d5+2'}, 
    included_skills={'bite', 'bite_adv'},
  },
  fist = {
    dice={'1d2'},
    included_skills={'martial_arts_adv'},
  },
}

function IsWeapon:getDice(player, condition)
  local weapon_dice = dice:new(self.weapon.DICE)
  local damage_type = self:getDamageType()
  
  if not self:isOrganic() and not damage_type == 'bullet' and condition then
    if     damage_type == 'pierce' then weapon_dice = weapon_dice + modifier.pierce[condition]    
    elseif damage_type == 'blunt'  then weapon_dice = weapon_dice/modifier.blunt[condition]      
    elseif damage_type == 'scorch' then weapon_dice = weapon_dice*modifier.scorch[condition]
    end
  elseif self:isOrganic() then    
    local organic_modifier = organic_modifier[self:getClassName()]
    if organic_modifier then
      local skill_count = 0
      for _, skill in ipairs(organic_modifier.included_skills) do
        if player.skills:check(skill) then skill_count = skill_count + 1 end
      end      
      if skill_count > 0 then
        local dice_str = organic_modifier.dice[skill_count]
        weapon_dice = dice:new(dice_str)  
      end    
    -- else organic weapon has no modifier or player lacks all included skills then use weapons default dice
    end
  end  
  
  local mastered_skill = self:getMasterSkill()
  if mastered_skill then --  this is restricted to only melee weapons, guns don't get rerolls (enable for guns later maybe?)
    if player.skills:check(mastered_skill) then 
      weapon_dice = weapon_dice^1
      weapon_dice = weapon_dice..'^^'
    end
  end   
  
  return tostring(weapon_dice) 
end

function IsWeapon:getConditionEffect(player) --, condition)  maybe for later...?
  local effect = self.weapon.CONDITION_EFFECT
  local duration, bonus_effect
  
  if player:isMobType('human') then
    if effect == 'burn' then
      duration = self:getFuelAmount()
      bonus_effect = self:isCombustionSource()
    end
  elseif player:isMobType('zombie') then
    if effect == 'entangle' then
      if player.skills:check('impale') then bonus_effect = true end -- possible to impale on crit hit
    end
  end
  
  return effect, duration, bonus_effect
end

return IsWeapon