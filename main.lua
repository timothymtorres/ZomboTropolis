-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")
display.setStatusBar (display.HiddenStatusBar)

-- Setup game here:
composer.mySettings = "Some settings that can be accessed in any scene (highscores, volume settings, etc)"
composer.myVolume = 100 

print()
print('NEW RUN')
print()
print()

local Map = require('code.location.map.class')
local Item = require('code.item.item')  -- for testing item generation in main.lua
Player = require('code.player.player')
table.copy = require('code.libs.copy')
table.inspect = require('code.libs.inspect')




local arm_CL = require('code.player.armor.item_class')

--[[
local building = require('code.location.building.class')
lookupItem = require('code.item.search')
lookupWeapon = require('code.item.weapon.search')
lookupEquipment = require('code.location.building.equipment.search')
lookupMedical = require('code.item.medical.search')
--]]

dummy = {}
print()
city = map:new(10)
main_player = player:new('Fran', 'zombie', city, 4, 4)
alt_player = player:new('Tim', 'human', city, 4, 4)

p_tile = alt_player:getTile()
p_tile.barricade.potential_hp = 28 
p_tile.barricade.hp = 20
p_tile.barricade:updateDesc()

--[[
for i=1, 10 do
  local y, x = 4, 4
  local mob = 'human'
  dummy[i] = player:new('dummy-'..i, mob, city, y, x)
  dummy[i]:takeAction('enter')
end
--]]

main_player:updateStat('hp', -49)

local toolbox = Item.Toolbox:new(4)
alt_player.inventory:insert(toolbox)

for i=1, 10 do
  local barricade = Item.Barricade:new('intact')
  alt_player.inventory:insert(barricade)
end

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

main_player:updateStat('xp', 1000)
alt_player:updateStat('xp', 1000)
--main_player.skills:buy(main_player, 'melee')
--main_player.condition.poison:add(7, 63)
--main_player.condition.burn:add('1d1+60', true)


-- Function to handle button events
local function handleTabBarEvent( event )
  --local index = {skills=1, player=2, contacts=3, events=4}  Not neccessary?
  local options = {
     effect = "fade",
     time = 500,
     --params = {selected = index[event.target._id]}  Not neccessary?
  } 
    --composer.removeScene('scenes.'..composer.getCurrentSceneName() )
    if active_timer then timer.cancel(active_timer) end   -- active_timer is a global defined in a scene used for picker wheel     
    composer.gotoScene('scenes.'..event.target._id, options)
end

local function swapPlayers()
  main_player, alt_player = alt_player, main_player
    
  local scene = composer.getSceneName('current')
  local options = {effect = "fade", time = 500} 
  --[[
  local button_index = {
    ['scene.map']   = 1,
    ['scene.action'] = 2,
    ['scene.skills'] = 3,
    ['scene.player'] = 4,
  }  
  --]]
  composer.removeScene(scene)
  composer.removeHidden()  
  composer.gotoScene(scene, options)
  --tab_bar:setSelected(button_index[scene])     
end

-- Configure the tab buttons to appear within the bar
local tabButtons = {
    {
        label = "Status",
        id = 'status',
        selected = true,
        onPress = handleTabBarEvent
    },  
    {
        label = 'Events',
        id = 'events',
        --selected = true,
        onPress = handleTabBarEvent
    },
    {
        label = "Map",
        id = 'map',
      --selected = true,
        onPress = handleTabBarEvent      
    },
    {
        label = "Action",
        id = 'action',
      --selected = true,
        onPress = handleTabBarEvent
    },        
    {
        label = "Skills",
        id = 'skills',
        --selected = true,
        onPress = handleTabBarEvent
    },
    {
        label = "Swap Players",
        id = 'swap',
        onPress = swapPlayers
    },
}

tab_bar = widget.newTabBar
{
    top = display.contentHeight-60,
    width = display.contentWidth,
    buttons = tabButtons
}

-- Use composer to go to our first game scene
composer.gotoScene("scenes.status")