
-- Item effects module

-- Define module
local M = {}
local itemSheetInfo = require('graphics.ss13.items')
local Object = require('code.libs.berry.Object')

function M.new(map, item, x, y)
    local fake_json_data = {
      image = 'graphics/ss13/items.png',
      imageSheetInfo = itemSheetInfo,
      name = 'background',
      height = 32,
      rotation = 0,  -- you may need to subtract map.world.rotation from rotation
      type = "item_effect",
      visible = true,
      width = 32,
      x = x - map.world.x,
      y = y - map.world.y,
    }

	local Effects_layer = map:getObjectLayer('Effects')

    local item_effect_bkgr = Object:new(fake_json_data, map, Effects_layer)
    Effects_layer:addObject(item_effect_bkgr)
    item_effect_bkgr:create()

    fake_json_data.name = string.lower(tostring(item))
    local item_effect = Object:new(fake_json_data, map, Effects_layer)
    Effects_layer:addObject(item_effect)
    item_effect:create()

    -- attach our background objec to item_effect
    item_effect.bkgr = item_effect_bkgr

	return item_effect
end

return M
