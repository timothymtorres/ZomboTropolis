print()
print('NEW RUN')
print()
print()

local Map = require('location/map/class')
local building = require('location/building/class')
player = require('player/class')
lookupItem = require('item/search')
lookupWeapon = require('item/weapon/search')
lookupEquipment = require('location/building/equipment/search')
lookupMedical = require('item/medical/search')

print()
city = map:new(1)
tilus = player:new('tilus', 'human', city, 1, 1)
dummy = player:new('dummy', 'zombie', city, 1, 1)


tilus:updateXP(1000)
tilus.skills:buy(tilus, 'melee')
print()
print()
tilus.skills:buy(tilus, 'military')
print()
print()
tilus.skills:buy(tilus, 'melee_adv')
print()
print()
tilus.skills:buy(tilus, 'medical')
print()
print()
tilus.skills:buy(tilus, 'recovery')
print()
print()
tilus.skills:buy(tilus, 'major_healing')

print()
print('THE END')

--result = tilus.skills:check('melee', 'repairs')
print('tilus:XP = '.. tilus:getXP())
--print('result - ', result)
print('tilus.skills.flags = '..tilus.skills.flags)
--for k,v in pairs(tilus.skills) do print(k,v) end

local med = lookupItem('FAK')
local med_ID = med:getID()

tilus.inventory:insert(med_ID)

tilus:updateHP(-30)

print()
print('HEAL ACTION')
print()
print('Default tilus HP - '..tilus:getHP() )
print('med_ID exists?', med_ID)

city[1][1]:move(tilus, 'inside')
city[1][1]:insert('generator')
city[1][1].generator:refuel()

math.randomseed( os.time() )

tilus:takeAction('item', med_ID, tilus, 1)

print('tilus AP - '..tilus:getAP() )
print('tilus HP - '..tilus:getHP() )

--[[

-- need to search and get weapon_ID
local weap = lookupWeapon('crowbar')
local weap_ID = weap:getID()
--insert 
tilus.inventory:insert(weap_ID)
-- get weapon_name/ID to use for attack func

city[1][1].barricade:updateHP(64)

local generator = lookupEquipment('generator')
city[1][1]:insert(generator)

for i=1, 51 do
  print('NEW ATTACK')
  print()
  tilus:takeAction('attack', city[1][1], weap_ID, 1)

  print('tilus AP - '..tilus:getAP() )
--print('generator HP - '..city[1][1].generator:getHP() )
  print('barricade HP - '..city[1][1].barricade:getHP() )
  print()
end
--]]


--[[
print('tilus table:')
for k,v in pairs(tilus) do print(k,v) end

print()
print('tile table:')
city[1][1]:insert(tilus)

for k,v in pairs(city[1][1].players) do print(k,v) end

city[1][1]:remove(tilus)

print()
print('tile table 2nd:')
for k,v in pairs(city[1][1].players) do print(k,v) end

city[1][1].building = building:new('warehouse')

print()
print('building table:')
for k,v in pairs(city[1][1].building) do print(k,v) end

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
print('tilus possible actions:')

actions = tilus:getActions()
for k,v in pairs(actions) do print(k,v) end

math.randomseed( os.time() )

for i=1, 30 do
  print()
  tilus:takeAction('search', city)
  print()
end

print('tilus inventory:')
for i,v in ipairs(tilus.inventory) do print(i,v) end
--]]