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

-- spawns test objects into the game
setupEnvironment('basic')

-- Use composer to go to our first game scene 
--composer.gotoScene('scenes.map')
composer.gotoScene('scenes.location')
--composer.gotoScene("scenes.status")