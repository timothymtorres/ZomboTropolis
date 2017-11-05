local class = require('code.libs.middleclass')
--[[
local e_list = require('code.item.list.equipment')
local g_list = require('code.item.list.gadget')
local j_list = require('code.item.list.junk')
local m_list = require('code.item.list.medical')
local w_list = require('code.item.list.weaponry')
local a_list = require('code.item.list.ammo')
local arm_list=require('code.item.list.armor')
local order = require('code.item.order')
--]]
local bit = require('plugin.bit')
local lshift, rshift, bor = bit.lshift, bit.rshift, bit.bor
local check = require('code.item.use.check')
local dice = require('code.libs.dice')

local item = class('item')

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

function item:initialize(condition_setting) 
  if type(condition_setting) == 'string' then self.condition = selectFrom(condition_spawn_odds[condition_setting])
  elseif type(condition_setting) == 'number' and condition_setting > 0 and condition_setting <= 4 then self.condition = condition_setting
  else error('Item initialization has a malformed condition setting')
  end
end

--[[  THESE ARE SERVER/DATABASE FUNCTIONS
function item:toBit() end

function item.toClass(bits) end
--]]

function item:canBeActivated(player)
  local item_name = self:getClassName()
  return (check[item_name] and pcall(check[item_name], player) ) or false
end

function item:hasConditions() return not self.condition_omitted end  -- not currently used (only use when condition is irrelevant to item) [newspapers?]

function item:isWeapon() return self.designated_weapon or false end

function item:isSingleUse() return self.durability == 0 end

function item:failDurabilityCheck(player)
  local durability = self.durability
  if self.master_skill then          -- skill mastery provides +20% durability bonus to items
    if self.durability > 1 then      -- but not to items that are limited usage (ie. only 4 use or single use)
      durability = player.skills:check(self.master_skill) and math.floor(self.durability*1.2 + 0.5) or durability
    end
  end
  return dice.roll(durability) <= 1
end

function item:updateCondition(num, player, inv_ID)
  self.condition = math.min(self.condition + num, 4)
  if self.condition <= 0 then player.inventory:remove(inv_ID) end -- item is destroyed
  return self.condition, num
end

function item:isConditionVisible(player) return player.skills:check(self:getClassCategory()) end

function item:getName() return self.name end

function item:getClass() return self.class end

function item:getClassName() return tostring(self.class) end

function item:getFlag() 
  local flag 
  local ID = item[self:getClassName()].ID
  flag = lshift(ID, 2)
  flag = bor(flag, self.condition)
  return flag
end

function item:getCondition() return self.condition end

local condition_states = {[1]='ruined', [2]='worn', [3]='average', [4]='pristine'}

function item:getConditionState() return condition_states[self.condition] or '???' end

function item:getClassCategory() return self.class_category end

function item:getWeight() return self.weight end

function item:getMasterSkill() return self.master_skill end

function item:__tostring() return self:getClassName() end

function item:dataToClass(...) -- this should be a middleclass function (fix later)
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
item:dataToClass(e_list, g_list, j_list, m_list, w_list, a_list, arm_list)

return item