local class = require('code.libs.middleclass')

local Inventory = class('Inventory')

function Inventory:initialize(player) self.player = player end

function Inventory:getItem(pos) return self[pos] end

function Inventory:getPos(item) return self[item] end

function Inventory:insert(item) 
  self[#self+1] = item 
  self[item] = #self
end

function Inventory:remove(obj)
  local position = type(obj) == 'number' and obj or self:getPos(obj)
  local item = type(obj) == 'table' and obj or self:getItem(obj) 

  -- put item:destroy() here?
  self[item] = nil 
  table.remove(self, position)

  -- update the inv_IDs
  for i, item_INST in ipairs(self) do self[item_INST] = i end
end

function Inventory:isPresent(obj) return self[obj] end

--[[  This is now getItem()
function Inventory:lookup(inv_ID)  -- get itemClass_INST   this method should be renamed to getItem()
  if inv_ID == nil or self[inv_ID] == nil then return error('Inventory:lookup invalid') end  
  return self[inv_ID]
end
--]]

function Inventory:search(item_name)  -- needs to be renamed or deprecated (this searches by strings, mainly used for flashlights)
  for inv_ID, item_INST in ipairs(self) do
    if item_INST:getName() == item_name then 
      return true, inv_ID 
    end
  end
  return false
end

function Inventory:catalog()
  local contents = {}
  for inv_ID=1, #self do contents[#contents + 1] = self[inv_ID] end
  return contents
end

function Inventory:updateDurability(obj, num)
  local position = type(obj) == 'number' and obj or self:getPos(obj)
  local item = type(obj) == 'table' and obj or self:getItem(obj)
  local player = self.player
  local is_single_use = item:isSingleUse()
  local failed_durability_test = not is_single_use and item:failDurabilityCheck(player)
  local condition 
 
  if not num and failed_durability_test then
    condition = item:updateCondition(-1)
  elseif num and not is_single_use then
    condition = item:updateCondition(num)   
  else -- no change to condition
    condition = nil
  end

  if condition == 0 or is_single_use then self:remove(inv_ID) end

  return condition
end

return Inventory