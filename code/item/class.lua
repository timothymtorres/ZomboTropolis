local class = require('code.libs.middleclass')
local b_list = require('code.item.list.barricade')
local e_list = require('code.item.list.equipment')
local g_list = require('code.item.list.gadget')
local j_list = require('code.item.list.junk')
local m_list = require('code.item.list.medical')
local w_list = require('code.item.list.weaponry')
local a_list = require('code.item.list.ammo')
local order = require('code.item.order')
local bit = require('plugin.bit')
local lshift, rshift, bor = bit.lshift, bit.rshift, bit.bor
local check = require('code.item.use.check')

local item = class('item')

local function selectFrom(spawn_list)
  local chance, total = math.random(), 0

  for condition_level, odds in ipairs(spawn_list) do
    total = total + odds
    if chance <= total then return condition_level - 1 end
  end
end

local condition_spawn_odds = {  -- used when spawning new item
  --ruined =    {[1] = 0.60, [2] = 0.25, [3] = 0.10, [4] = 0.05},
  unpowered = {[1] = 0.25, [2] = 0.40, [3] = 0.25, [4] = 0.10},
  powered =   {[1] = 0.10, [2] = 0.25, [3] = 0.40, [4] = 0.25}, 
}

function item:initialize(location_status) 
--print(condition_spawn_odds, location_status)
--print(condition_spawn_odds[location_status])
  self.condition = selectFrom(condition_spawn_odds[location_status])
--print('self.condition - ', self.condition)
end

--[[  THESE ARE SERVER/DATABASE FUNCTIONS
function item:toBit() end

function item.toClass(bits) end
--]]

function item:updateUses(num) self.uses = self.uses + num end

function item:canBeActivated(player)
  local item_name = self:getClassName()
  return (check[item_name] and pcall(check[item_name], player) ) or false
end

function item:hasConditions() return not self.condition_omitted end

function item:hasUses() return self.designated_uses and true or false end

function item:isWeapon() return self.designated_weapon or false end

function item:isConditionVisible(player) end

function item:getName() return self.name end

function item:getClass() return self.class end

function item:getClassName() return tostring(self.class) end

function item:getFlag() 
  local flag 
  local ID = item[self:getClassName()].ID
print('getFlag()', ID, 2)
  flag = lshift(ID, 2)
  flag = bor(flag, self.condition)
  
  if self:hasUses() then 
    flag = lshift(flag, 4)
    flag = bor(flag, self.uses)
  end
  
  return flag
end

--[[
function item:getID() 
print(item, self:getClassName())
print(item[self:getClassName()], item[self:getClassName()].ID)
  return item[self:getClassName()].ID end
--]]

function item:getUses() return self.uses end

function item:getCondition() return self.condition end

local condition_states = {[0]='ruined', [1]='worn', [2]='average', [3]='pristine'}

function item:getConditionState() return condition_states[self.condition] or '???' end

function item:getClassCategory() return self.class_category end

function item:getWeight() return self.weight end

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
item:dataToClass(b_list, e_list, g_list, j_list, m_list, w_list, a_list)

return item