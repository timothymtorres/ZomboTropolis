local Server = require('code.server.server')
local Map = require('code.location.map')
local Items = require('code.item.items')  -- for testing item generation in main.lua
local Zombie = require('code.player.zombie.zombie')
local Human = require('code.player.human.human')

local zombie_dummies = {}
local human_dummies = {}

-- make map init size based on map size from json? instead of hardcoded value
local city = Map:new('ZomboTropolis', 7)
Server:addMap(city)
--local y, x = 20, 5   --19,34

--main_player = city:spawnPlayer('human') --Human:new(nil, city, y, x)
--main_player.stats:update('ap', -45)

alt_player = city:spawnPlayer('zombie') --Zombie:new(nil, city, y, x)
alt_player.status_effect:add('hide')

for i=1, 1 do
  zombie_dummies[i] = city:spawnPlayer('zombie') --Zombie:new(nil, city, y, x)
  zombie_dummies[i].stats:update('hp', -100)
end

for i=1, 1 do
  human_dummies[i] = city:spawnPlayer('human') --Human:new(nil, city, y, x)
  human_dummies[i].stats:update('hp', -100)
end

--[[
print(t, headers)
for k,v in pairs(headers) do print(k,v) end
for k,v in pairs(t) do
	for kk,vv in pairs(v) do print(k, kk, vv) end
end
--]]
--print(table.inspect(headers))
--{header1, header2, header3}

--print(table.inspect(t))
-- for item
--{{header1=value, header2=value2, etc.}, {header1=value, ...}}

--[[
-- populate our item weighted values
for item_info in ipairs(t) do
	local item = item_info.Item
	for building, weight in pairs(item) do
		if building ~= 'Item' then -- or search_odds
			building.search_odds.inside[item] = weight
		end
	end
end
--]]

--[[
p_tile = alt_player:getTile()

p_tile.barricade.potential_hp = 28
p_tile.barricade.hp = 20
p_tile.barricade:updateHP(1)

p_tile:install('generator', 4)
p_tile:install('transmitter', 4)
p_tile:install('terminal', 4)
p_tile.equipment.generator:refuel()
--]]
