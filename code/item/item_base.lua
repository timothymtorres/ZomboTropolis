local class = require('code.libs.middleclass')
local dice = require('code.libs.dice')

local ItemBase = class('ItemBase')

local function selectFrom(spawn_list)
  local chance, total = math.random(), 0

  for condition_level, odds in ipairs(spawn_list) do
    total = total + odds
    if chance <= total then return condition_level end
  end
end

local condition_spawn_odds = {  -- used when spawning new item
  ruined =    {[1] = 0.60, [2] = 0.25, [3] = 0.10, [4] = 0.05},
  ransacked = {[1] = 0.25, [2] = 0.40, [3] = 0.25, [4] = 0.10},
  intact =    {[1] = 0.10, [2] = 0.25, [3] = 0.40, [4] = 0.25}, 
}

function ItemBase:initialize(condition_setting) 
  if type(condition_setting) == 'string' then self.condition = selectFrom(condition_spawn_odds[condition_setting])
  elseif type(condition_setting) == 'number' and condition_setting > 0 and condition_setting <= 4 then self.condition = condition_setting
  else error('Item initialization has a malformed condition setting')
  end
end

--function ItemBase:hasConditions() return not self.CONDITION_OMITTED end  -- not currently used (only use when condition is irrelevant to item) [newspapers?]

function ItemBase:isWeapon() return self.weapon or false end

function ItemBase:isMedical() return self.medical or false end

function ItemBase:isArmor() return self.armor or false end

function ItemBase:isReloadable() return self.reload or false end

function ItemBase:isSingleUse() return self.DURABILITY == 0 end

function ItemBase:failDurabilityCheck(player)
  local durability
  if self.MASTER_SKILL then          -- skill mastery provides +20% durability bonus to items
    if self.DURABILITY > 1 then      -- but not to items that are limited usage (ie. only 4 use or single use)
      durability = player.skills:check(self.MASTER_SKILL) and math.floor(self.DURABILITY*1.2 + 0.5) or durability
    end
  end
  return dice.roll(durability or self.DURABILITY) <= 1
end

function ItemBase:updateCondition(num, player, inv_ID)
  self.condition = math.min(self.condition + num, 4)
  if self.condition <= 0 then player.inventory:remove(inv_ID) end -- item is destroyed
  return self.condition, num
end

function ItemBase:isConditionVisible(player) return player.skills:check(self.CLASS_CATEGORY) end

function ItemBase:getClass() return self.class end

function ItemBase:getCondition() return self.condition end

local condition_states = {[1]='ruined', [2]='worn', [3]='average', [4]='pristine'}

function ItemBase:getConditionState() return condition_states[self.condition] or '???' end

function ItemBase:getClassCategory() return self.CLASS_CATEGORY end

function ItemBase:getWeight() return self.WEIGHT end

function ItemBase:__tostring() return tostring(self.class) end

return ItemBase