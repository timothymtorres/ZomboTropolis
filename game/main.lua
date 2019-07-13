-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")
local setupEnvironment = require('environment.setup')
local berry = require('code.libs.berry')
table.inspect = require('code.libs.inspect')
display.setStatusBar(display.HiddenStatusBar)

-- Setup game here:
composer.mySettings = "Some settings that can be accessed in any scene (highscores, volume settings, etc)"
composer.myVolume = 100 

-- spawns test objects into the game
setupEnvironment('basic')

-- Use composer to go to our first game scene
composer.gotoScene('scenes.main_menu') 
--composer.gotoScene('scenes.map')
--composer.gotoScene('scenes.location')
--composer.gotoScene("scenes.status")
--composer.showOverlay( "scenes.overlays.character_cosmetics", options )
--composer.gotoScene('scenes.overlays.character_cosmetics')

-- load world as a global
world = berry:new( "graphics/map/world.json", "graphics/map" )
world.isVisible = false