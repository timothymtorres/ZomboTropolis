local csv_helpers = require('code.libs.csv_helpers')
local class = require('code.libs.middleclass')
local Item = require('code.item.item')
local IsArmor = require('code.item.mixin.is_armor')
local IsWeapon = require('code.item.mixin.is_weapon')
--local IsAmmo = require('code.item.mixin.is_ammo')  add later
--local Ammo = require('code.item.items.ammo') add later
local Armor = require('code.item.items.armor')
local Gadget = require('code.item.items.gadget')
local Junk = require('code.item.items.junk')
local Machinery = require('code.item.items.machinery')
local Medical = require('code.item.items.medical')
local Tool = require('code.item.items.tool')

local Items = {}

-- this combines the item activate/critera functions with the CSV data into one table
local addFunctionsToItems = function(items_table)
  for item, functions in pairs(items_table) do
    -- merge functions & CSV data
    for k, v in pairs(functions) do Items[item][k] = v end
  end
end

local item_path = system.pathForFile("spreadsheet/data/player - items.csv", 
                                     system.ResourceDirectory)
local item_csv = csv_helpers.convertToLua(item_path)

-- import data into item class
for i, item in ipairs(item_csv) do
  local item_class = class(item.NAME, Item)
  for k, v in pairs(item) do item_class[k] = v end

  Items[i] = item_class
  Items[item.NAME] = item_class
end

addFunctionsToItems(Armor)
addFunctionsToItems(Gadget)
addFunctionsToItems(Junk)
addFunctionsToItems(Machinery)
addFunctionsToItems(Medical)
addFunctionsToItems(Tool)

-------------------------------------------------------
-- time to add all the different mixins to items
-------------------------------------------------------

local weapon_path = system.pathForFile("spreadsheet/data/player - weapons.csv", 
                                       system.ResourceDirectory)
local weapon_csv = csv_helpers.convertToLua(weapon_path)

-- import weapon data into items 
for i, weapon in ipairs(weapon_csv) do
  if not weapon.ORGANIC then -- organic weapons don't count as items
    local item = Items[weapon.NAME]
    item:include(IsWeapon)
    item.weapon = {}
    for k, v in pairs(weapon) do item.weapon[k] = v end
  end
end

local armor_path = system.pathForFile("spreadsheet/data/player - armors.csv", 
                                      system.ResourceDirectory)
local armor_csv = csv_helpers.convertArmor(armor_path)

-- import armor data into items 
for i, armor in ipairs(armor_csv) do
  if not armor.ORGANIC then -- organic armors don't count as items
    local item = Items[armor.NAME]
    item:include(IsArmor) 
    item.armor = {}
    for k, v in pairs(armor) do item.armor[k] = v end
  end
end

return Items