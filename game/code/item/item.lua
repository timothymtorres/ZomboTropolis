local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')
local lume = require('code.libs.lume')

local Item = class('Item')

local condition_spawn_odds = {  -- used when spawning new item
  ruined =    {10,  5,  3,  2}, -- 50% ruin, 25% worn, 15% average, 10% pristine
  worn =      { 4, 10,  4,  2}, -- 20% ruin, 50% worn, 20% average, 10% pristine
  average =   { 2,  4, 10,  4}, -- 10% ruin, 20% worn, 50% average, 20% pristine
  pristine =  { 2,  3,  5, 10}, -- 10% ruin, 15% worn, 25% average, 50% pristine
}

local integrity_to_condition = {
  ruined =    'ruined', -- ruined buildings (and outside locations) generate ruined items
  ransacked = 'worn',   -- ransacked buildings generate worn items
  intact =    'average',-- intact buildings generate average items
}

function Item:initialize(condition_setting) 
  if type(condition_setting) == 'string' then
    condition_setting = integrity_to_condition[condition_setting] or condition_setting
    self.condition = lume.weightedchoice(condition_spawn_odds[condition_setting])
  elseif type(condition_setting) == 'number' and condition_setting > 0 and condition_setting <= 4 then self.condition = condition_setting
  else error('Item initialization has a malformed condition setting')
  end
end

--function Item:hasConditions() return not self.CONDITION_OMITTED end  -- not currently used (only use when condition is irrelevant to item) [newspapers?]

function Item:isWeapon() return self.weapon or false end

function Item:isMedical() return self.medical or false end

function Item:isArmor() return self.armor or false end

function Item:isReloadable() return self.reload or false end

function Item:isSingleUse() return self.DURABILITY == 0 end

function Item:failDurabilityCheck(player, degrade_multiplier)
  local degrade_multiplier = multiplier or 1
  local durability
  local master_skill = (self.weapon and self.weapon.MASTER_SKILL) or self.MASTER_SKILL -- item.weapon.weapon_master_skill vs item.durability_master_skill

  
  if master_skill then   -- skill mastery provides +20% durability bonus to items
    if self.DURABILITY > 1 then      -- but not to items that are limited usage (ie. only 4 use or single use)
      durability = player.skills:check(master_skill) and math.floor(self.DURABILITY*1.2 + 0.5) or durability
    end
  end
  return dice.roll(durability or self.DURABILITY) <= degrade_multiplier
end

function Item:updateCondition(num)
  self.condition = math.max(math.min(self.condition + num, 4), 0)
  return self.condition
end

function Item:isConditionVisible(player) return player.skills:check(self.CLASS_CATEGORY) end

function Item:getCondition() return self.condition end

local condition_states = {[1]='ruined', [2]='worn', [3]='average', [4]='pristine'}

function Item:getConditionStr() return condition_states[self.condition] end

function Item:getClassCategory() return self.CLASS_CATEGORY end

function Item:getWeight() return self.WEIGHT end

function Item:__tostring() return tostring(self.class.name) end

return Item