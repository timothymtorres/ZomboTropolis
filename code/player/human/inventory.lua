local class = require('code.libs.middleclass')

local Inventory = class('Inventory')

function Inventory:initialize(player)
  self.player = player
  --self.radio_receivers = {}  
end

function Inventory:insert(item_INST) self[#self+1] = item_INST end  

function Inventory:remove(inv_ID) table.remove(self, inv_ID) end

function Inventory:check(inv_ID) return (self[inv_ID] and true) or false end

function Inventory:lookup(inv_ID)  -- get itemClass_INST
  if inv_ID == nil or self[inv_ID] == nil then return error('Inventory:lookup invalid') end  
  return self[inv_ID]
end

function Inventory:search(item_name)
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

function Inventory:updateDurability(inv_ID, num)
  local item, player = self[inv_ID], self.player
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

--[[ This code is deprecated and needs to be rewritten

function Inventory:updateRadio(player, mode, freq)  
  local receivers = self.radio_receivers
  
  if mode == 'insert' then receivers[freq] = receivers[freq] + 1  
  elseif mode == 'remove' then receivers[freq] = receivers[freq] - 1 end
  channel[mode](channel, freq, player)
end
--]]

return Inventory