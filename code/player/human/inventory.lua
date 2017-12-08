local class = require('code.libs.middleclass')

--[[
  player.inventory = {
    [1] = crowbar,
    [2] = bandage,
    [3] = pistol,
    ...,  -- (inv_ID = itemClass_INST)
  }
--]]

function inventory:initialize(player)
  self = {player = player}
  --self.radio_receivers = {}  
end

function inventory:insert(item_INST) self[#self+1] = item_INST end  

function inventory:remove(inv_ID) table.remove(self, inv_ID) end

function inventory:reset() self = inventory:new() end  -- do we really need this?

function inventory:check(inv_ID) return (self[inv_ID] and true) or false end

function inventory:lookup(inv_ID)  -- get itemClass_INST
  if inv_ID == nil or self[inv_ID] == nil then return error('inventory:lookup invalid') end  
  return self[inv_ID]
end

function inventory:search(item_name)
  for inv_ID, item_INST in ipairs(self) do
    if item_INST:getName() == item_name then 
      return true, inv_ID 
    end
  end
  return false
end

function inventory:catalog()
  local contents = {}
  for inv_ID=1, #self do contents[#contents + 1] = self[inv_ID] end
  return contents
end

function inventory:updateDurability(inv_ID)
  local itemObj = self[inv_ID] 
  local player = self.player
  
  if itemObj:isSingleUse() then 
    self:remove(inv_ID) 
  elseif itemObj:failDurabilityCheck(player) then 
    local condition = itemObj:updateCondition(-1)

    if condition <= 0 then
      player.log:append('Your '..tostring(itemObj)..' is destroyed!')
      self:remove(inv_ID)
    elseif itemObj:isConditionVisible(player) then
      player.log:append('Your '..tostring(itemObj)..' degrades to a '..itemObj:getConditionState()..' state.')  
    end    
  end
end

--[[ This code is deprecated and needs to be rewritten

function inventory:updateRadio(player, mode, freq)  
  local receivers = self.radio_receivers
  
  if mode == 'insert' then receivers[freq] = receivers[freq] + 1  
  elseif mode == 'remove' then receivers[freq] = receivers[freq] - 1 end
  channel[mode](channel, freq, player)
end
--]]

return inventory