local item_CL = require('code.item.class')
local order = require('code.item.order')

local item_list = order

for ID, name in ipairs(item_list) do 
  item_list[name] = ID  -- do we need this? maybe...?
  item_CL[name].ID = ID
end

-- ID can be a num or str
local function lookup(ID) return item_CL[ID] end

return lookup