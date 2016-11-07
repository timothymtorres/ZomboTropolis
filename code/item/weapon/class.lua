local class = require('code.libs.middleclass')
local item = require('code.item.class')
local chanceToHit = require('code.item.weapon.chanceToHit')
local w_list = require('code.item.weapon.list')
local entangle = require('code.player.condition.entangle')
local dice = require('code.libs.rl-dice.dice')

local weapon = class('weapon', item)

function weapon:initialize(condition)
  self.condition = condition
end

function weapon:isOrganic() return self.organic or false end

function weapon:isHarmless() return self.no_damage or false end

function weapon:isSkillRequired() return (self.skill_required and true) or false end

function weapon:isCombustionSource() return self.combustion_source or false end

function weapon:isSingleUse() return self.one_use or false end

function weapon:hasConditionEffect(player)
  if self:getClassName() == 'claw' and not player.skills:check('grapple') then 
    return false -- if attacking with claws and missing grapple skill then no condition effect  
  end
  return (self.condition_effect and true) or false 
end

function weapon:getID() return self.weapon_ID end  -- do we need this?

function weapon:getName() return self.name end

function weapon:getClass() return self.class end

function weapon:getClassName() return tostring(self.class) end

function weapon:getSkillRequired() return self.skill_required end

function weapon:getFuelAmount() return self.fuel_amount end

function weapon:getCrit() return self.critical end

function weapon:getStyle() return self.attack_style end

function weapon:getMasterSkill() return self.master_skill end
  
function weapon:getGroup() return self.group end 
 
function weapon:getDamageType() return self.damage_type end 

function weapon:getObjectDamage(type) return (self.object_damage and self.object_damage[type]) or false end

--function weapon:getWeaponID() return self.weapon_ID end

local modifier = {
  power_claw =   0.15,                      -- to-hit% bonus (for equipment and buildings)    
  zombie_melee={-0.05,  0.00, 0.05, 0.10},  -- to-hit%
  projectile = {-0.10, -0.05, 0.00, 0.05},  -- to-hit%
   
       blunt = {-2, -1, 0, 1},              -- range
      pierce = {-2, -1, 0, 1},              -- bonus
      scorch = {-2, -1, 0, 1},              -- dice               
}

function weapon:getAccuracy(player, target)
  local accuracy_bonus
  
  if player:isMobType('zombie') then
    if self:getStyle() == 'melee' then
      if entangle.isTangledTogether(player, target) then
        if player.condition.entangle:isImpaleActive() then accuracy_bonus = modifier.zombie_melee[4]
        else accuracy_bonus = modifier.zombie_melee[3]
        end
      elseif target:getClassName() ~= 'player' then -- equipment or building
        if player.skills:check('power_claw') then accuracy_bonus = modifier.power_claw end
      end
      --if maimed condition then accuracy_bonus = modifier.zombie_melee[1]
    end
  else  -- is human, thus weapon is item
    accuracy_bonus = self.damage_type == 'bullet' and modifier.projectile[self.condition]
  end
  
  -- accuracy bonus ONLY applies to ranged human weapons and zombie melee attacks  
  accuracy_bonus = accuracy_bonus or 0
  return self.accuracy, accuracy_bonus
end

function weapon:getToHit(player, target) return chanceToHit(player, target, self) end

local organic_modifier = {
  claw = {
    dice={'1d4', '2d4'}, 
    included_skills={'claw', 'dual_claw'},
  },
  bite = {
    dice={'1d5+1', '1d5+2'}, 
    included_skills={'bite', 'power_bite'},
  },
  fist = {
    dice={'1d2'},
    included_skills={'martial_arts_adv'},
  },
}

function weapon:getDice(player, condition)
  local weapon_dice = dice:new(self.dice)
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
    end 
    -- else organic weapon has no modifier or player lacks all included skills then use weapons default dice
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

local skill_effects = {
  poison = {
      order = {'venom_adv', 'venom', 'stinger'},
    stinger = {duration = '1d2+2', amount='1d5+10'},
      venom = {duration = '1d3+2', amount='1d7+15'},
  venom_adv = {duration = '1d4+3', amount='1d10+20'},
  },
  entangle = {
    
  }
}

function weapon:getConditionEffect(player) --, condition)  maybe for later...?   
  local effect = self.condition_effect
  local duration, bonus_effect
  
  if player:isMobType('human') then
    if effect == 'burn' then
      duration = weapon:getFuelAmount()
      bonus_effect = weapon:isCombustionSource()
    elseif effect == 'decay' then
    
    end
  elseif player:isMobType('zombie') then
    if effect == 'poison' then
      for _, skill in ipairs(skill_effects.poison.order) do
        if player.skills:check(skill) then
          duration = skill_effects.poison[skill].duration
          bonus_effect = skill_effects.poison[skill].amount
          break
        end
      end
    elseif effect == 'infection' then
      
    elseif effect == 'entangle' then
      if player.skills:check('impale') then bonus_effect = true end -- possible to impale on crit hit
    end
  end
  
  return effect, duration, bonus_effect
end

function weapon:dataToClass(...) -- this should be a middleclass function (fix later)
  local combined_lists = {...}
  for _, list in ipairs(combined_lists) do
    for obj in pairs(list) do
      self[obj] = class(obj, self)
    --[[  this is not neccessary?  
      self[obj].initialize = function(self_subclass, condition)
        self.initialize(self_subclass, condition)
      end
    --]]  
      for field, data in pairs(list[obj]) do self[obj][field] = data end
    end
  end
end

-- turn our list of weaponry into weapon class
weapon:dataToClass(w_list)
  
return weapon  