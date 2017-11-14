local class = require('code.libs.middleclass')
local bit = require('plugin.bit')
local lshift, rshift, bor = bit.lshift, bit.rshift, bit.bor
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

--[[  THESE ARE SERVER/DATABASE FUNCTIONS
function ItemBase:toBit() end

function ItemBase.toClass(bits) end
--]]

function ItemBase:canBeActivated(player)
  local item_name = self:getClassName()
  return (check[item_name] and pcall(check[item_name], player) ) or false
end

function ItemBase:hasConditions() return not self.condition_omitted end  -- not currently used (only use when condition is irrelevant to item) [newspapers?]

function ItemBase:isWeapon() return self.designated_weapon or false end

function ItemBase:isSingleUse() return self.durability == 0 end

function ItemBase:failDurabilityCheck(player)
  local durability = self.durability
  if self.master_skill then          -- skill mastery provides +20% durability bonus to items
    if self.durability > 1 then      -- but not to items that are limited usage (ie. only 4 use or single use)
      durability = player.skills:check(self.master_skill) and math.floor(self.durability*1.2 + 0.5) or durability
    end
  end
  return dice.roll(durability) <= 1
end

function ItemBase:updateCondition(num, player, inv_ID)
  self.condition = math.min(self.condition + num, 4)
  if self.condition <= 0 then player.inventory:remove(inv_ID) end -- item is destroyed
  return self.condition, num
end

function ItemBase:isConditionVisible(player) return player.skills:check(self:getClassCategory()) end

function ItemBase:getName() return self.name end

function ItemBase:getClass() return self.class end

function ItemBase:getClassName() return tostring(self.class) end

function ItemBase:getFlag() 
  local flag 
  local ID = item[self:getClassName()].ID
  flag = lshift(ID, 2)
  flag = bor(flag, self.condition)
  return flag
end

function ItemBase:getCondition() return self.condition end

local condition_states = {[1]='ruined', [2]='worn', [3]='average', [4]='pristine'}

function ItemBase:getConditionState() return condition_states[self.condition] or '???' end

function ItemBase:getClassCategory() return self.class_category end

function ItemBase:getWeight() return self.weight end

function ItemBase:getMasterSkill() return self.master_skill end

function ItemBase:__tostring() return self:getClassName() end

function ItemBase:dataToClass(...) -- this should be a middleclass function (fix later)
  local combined_lists = {...}
  for _, list in ipairs(combined_lists) do
    for obj in pairs(list) do
      self[obj] = class(obj, self)
    --[[  
      self[obj].initialize = function(self_subclass)
        self.initialize(self_subclass)
      end
    --]]  
      for field, data in pairs(list[obj]) do self[obj][field] = data end
    end  
  end
  
  local count = 0
  for ID, obj in ipairs(order) do
    self[ID] = self[obj]
    self[obj].ID = ID
  end
end

-- turn our list of objs into item class
ItemBase:dataToClass(e_list, g_list, j_list, m_list, w_list, a_list, arm_list)

return ItemBase