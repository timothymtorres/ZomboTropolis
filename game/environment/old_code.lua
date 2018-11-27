--[[
for i=1, 10 do
  local y, x = 4, 4
  local mob = 'human'
  dummy[i] = player:new('dummy-'..i, mob, city, y, x)
  dummy[i]:takeAction('enter')
end
--]]

--[[
main_player.stats:update('hp', -49)

local toolbox = Items.Toolbox:new(4)
alt_player.inventory:insert(toolbox)

for i=1, 2 do
  local barricade = Items.Barricade:new('intact')
  alt_player.inventory:insert(barricade)
end
--]]

--[[
local firesuit_INST = Item.firesuit:new('ruined')
alt_player.inventory:insert(firesuit_INST)
alt_player.armor:equip('firesuit', firesuit_INST:getCondition())

print('---------')
print('SYRINGE_ISNT IS:', syringe_INST, syringe_INST:getCondition())
print('---------')

alt_player:takeAction('syringe', 1, main_player)
--Outcome.Item('syringe', alt_player, 1, main_player)
--]]

--[[
for i=1, 100 do
  local y, x = math.random(1,10), math.random(1,10)
  local mob = math.random() > 0.5 and 'human' or 'zombie'
  dummy[i] = player:new('dummy-'..i, mob, city, y, x)
  if math.random() > 0.5 then dummy[i]:takeAction('enter') end
end
--]]

--[[

dummy:updateStat('xp', 1000)
dummy.skills:buy(dummy, 'hive')
dummy.skills:buy(dummy, 'stinger')

local weapon = require('code.Item.weapon.class')
local sting = weapon.sting:new()

for i=1, 3 do
  dummy:takeAction('attack', main_player, sting)
end

--]]

--[[
main_player.stats:update('xp', 1000)
alt_player.stats:update('xp', 1000)
--]]

--main_player.skills:buy(main_player, 'melee')
--main_player.condition.poison:add(7, 63)
--main_player.condition.burn:add('1d1+60', true)