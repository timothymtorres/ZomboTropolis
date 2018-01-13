print()
print('BUILDING TEST RUN')
print()
print()

local Map = require('location/map')
local building = require('location/building/class')
local player = require('player/class')
local lookupItem = require('item/search')
local lookupArea = require('location/search')
local lookupEquipment = require('location/building/equipment/search')

city = map:new(1)
tilus = player:new('tilus', 'human', city, 1, 1)

local location = lookupArea('warehouse')
local location_type = location:getName()

city[1][1] = location:new(location_type)

print()
print('barrier test')
for k,v in pairs(city[1][1]) do print(k,v) end

local generator, transmitter, terminal = lookupEquipment('generator'), lookupEquipment('transmitter'), lookupEquipment('terminal')

city[1][1]:insert(generator)
city[1][1]:insert(transmitter)
city[1][1]:insert(terminal)

print()
print('building table:')

print('terminal')
for k,v in pairs(city[1][1].terminal) do print(k,v) end
print()
print('transmitter')
for k,v in pairs(city[1][1].transmitter) do print(k,v) end
print()
print('generator')
for k,v in pairs(city[1][1].generator) do print(k,v) end

--[[
city[1][1].building:insert(tilus)

print()
print('building table tilus:')

for k,v in pairs(city[1][1].building.players) do print(k,v) end

print()
print('building table tilus removed:')

city[1][1].building:remove(tilus)

for k,v in pairs(city[1][1].building.players) do print(k,v) end

city[1][1]:insert(tilus)

print()
print('tile table tilus:')

for k,v in pairs(city[1][1].players) do print(k,v) end

print()
--]]
