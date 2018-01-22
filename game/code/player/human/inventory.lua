local class = require('code.libs.middleclass')

local Inventory = class('Inventory')

function Inventory:initialize(player) self.player = player end

function Inventory:getItem(pos) return self[pos] end

function Inventory:getPos(item) return self[item] end

function Inventory:isPresent(obj) return self[obj] end  -- obj can be a position or item

function Inventory:insert(item) 
  self[#self+1] = item
  self[item] = #self
end

function Inventory:remove(item)
  -- put item:destroy() here?
  self[item] = nil 
  table.remove(self, self:getPos(item))
  for i, item_INST in ipairs(self) do self[item_INST] = i end  -- updates the pos for items in inventory
end

function Inventory:searchForItem(class_name)
  for _, item in ipairs(self) do
    if item:isInstanceOf(class_name) then return item end
  end
end

function Inventory:catalog()
  local contents = {}
  for inv_ID=1, #self do contents[#contents + 1] = self[inv_ID] end
  return contents
end

function Inventory:updateDurability(item, num)
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

  if condition == 0 or is_single_use then self:remove(item) end
  return condition
end

return Inventory