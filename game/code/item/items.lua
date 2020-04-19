local csv_helpers = require('code.libs.csv_helpers')
local class = require('code.libs.middleclass')
local Item = require('code.item.item')

local Items = {}

-- import class data into location class
local item_path = system.pathForFile("spreadsheet/data/player - items.csv", system.ResourceDirectory)
local item_list = csv_helpers.convertToLua(item_path)

for i, item in ipairs(item_list) do
  local item_class = class(item.NAME, Item)
  -- copy our data to our location class
  for k, v in pairs(item) do item_class[k] = v end

  Items[i] = item_class
  Items[item.NAME] = item_class
end


return Items