
-- Item effects module

-- Define module
local M = {}
local itemSheetInfo = require('graphics.ss13.items.items')
local Object = require('code.libs.berry.Object')

function M.new(object, map, item, x, y)
--[[
	local Effects_layer = map:getObjectLayer('Effects')

print(table.inspect(Effects_layer, {depth=2}))

    local item_effect = Effects_layer:getObject('meowth')
	transition.to( item_effect.sprite, { time=1, x=x, y=y, iterations = 1} )
--]]

    local fake_json_data = {
      image = 'graphics/ss13/items/items.png',
      imageSheetInfo = itemSheetInfo,
      name = string.lower(tostring(item)),
      height = 32,
      rotation = 0,  -- you may need to subtract map.world.rotation from rotation
      type = "item_effect",
      visible = true,
      width = 32,
      x = x - map.world.x,
      y = y - map.world.y,
    }

	local Effects_layer = map:getObjectLayer('Effects')

    local item_effect = Object:new(fake_json_data, map, Effects_layer)
    Effects_layer:addObject(item_effect)
    item_effect:create()

print('---------------------')
print('item_effect vars')
print('---------------------')
for k,v in pairs(item_effect) do print(k,v) end
print('---------------------')
for k,v in pairs(item_effect.sprite) do print(k,v) end

	transition.to( item_effect, { time=1, x=x, y=y, iterations = 1} )




	--[[
	-- Create display group to hold visuals
	local group = display.newGroup()

	local itemSheet = graphics.newImageSheet('graphics/ss13/items/items.png', itemSheetInfo:getSheet())

	item = display.newImage(itemSheet, itemSheetInfo:getFrameIndex('crowbar'))
	item.x = x - 100
	item.y = y

	item_bkgr = display.newImage(itemSheet, itemSheetInfo:getFrameIndex('background'))
	item_bkgr.x = x - 100
	item_bkgr.y = y

	group:insert(item_bkgr)
	group:insert(item)

	function group:finalize()
		-- On remove, cleanup instance 
	end
	group:addEventListener( "finalize" )

	-- Return instance
	return group
	--]]
end

return M
