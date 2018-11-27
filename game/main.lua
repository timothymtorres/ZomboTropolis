-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")
local setupEnvironment = require('environment.setup')
table.inspect = require('code.libs.inspect')
display.setStatusBar (display.HiddenStatusBar)

-- Setup game here:
composer.mySettings = "Some settings that can be accessed in any scene (highscores, volume settings, etc)"
composer.myVolume = 100 

print()
print('MAIN.LUA TEST RUN')
print()
print()

-- this sets up our items/objects/mobs for testing/debugging purposes in the game
-- here you can load for instance, a generator full of fuel, a hurt character, spawning items,
-- and performing actions with players
setupEnvironment('basic')

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
  --
  --local button_index = {
  --  ['scene.map']   = 1,
  --  ['scene.action'] = 2,
  --  ['scene.skills'] = 3,
  --  ['scene.player'] = 4,
  --}  
  --
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
        label = "Room",
        id = 'room',
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
composer.gotoScene('scenes.map')
--composer.gotoScene('scenes.room')
--composer.gotoScene("scenes.status")