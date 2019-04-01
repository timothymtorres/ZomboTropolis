-----------------------------------------------------------------------------------------
--
-- location.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local berry = require( 'code.libs.berry' )
local widget = require('widget')

local location

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local phone_screen_width, phone_screen_height = display.contentWidth, display.contentHeight -- 320x480
local player_stage = main_player:getStage()
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  -- Load our location
  local y, x = main_player:getPos()
  local tile_gid = world:getGID('Location Template ID', y, x)
  local template_name = world.cache.properties[tile_gid].template
  local filename = "graphics/locations/"..template_name.. ".json"
  location = berry:new( filename, "graphics/ss13" )

  location:setExtension("scenes.objects.")
  location:extend("door", "barricade")  -- entrance
  location:extend("apc", "terminal", "generator", "transmitter") -- equipment

  local player_location = main_player:getLocation()
  local is_player_inside_building = player_location:isBuilding() and main_player:isStaged('inside')

  if is_player_inside_building then
    -- display our machines
    local building_has_power = player_location:isPowered()
    local machines = player_location:getEquipment()
    for machine_type, _ in pairs(machines) do
      local machine = location:getObjects( {type=machine_type} )
      machine:install()
      if building_has_power then machine:setPower('on') end
    end

    -- display our door
    local doors = { location:getObjects( {type='door'} ) }
    local is_door_present = player_location:isPresent('door')
    for _, door in ipairs(doors) do
      door:setAlpha(is_door_present)
      door:setFrame( player_location.door:getHP() + 1 )
    end

    -- display our barricades
    local barricades = { location:getObjects( {type='barricade'} ) }
    local is_cade_present = player_location:isPresent('barricade')
    for _, barricade in ipairs(barricades) do
      barricade:setAlpha(is_cade_present)
      barricade:setFrame( player_location.barricade:getState() )
    end

  end

  return sceneGroup
end

local max, acceleration, dy, dx = 375, 5, 0, 0, 0, 0
local max_scale, min_scale = 1.25, 0.75  -- only applies to zoom in/out

-- this is an event listener function to control zooming
local function zooming( event )
  local phase = event.phase
  local name = event.keyName

  if phase == "down" then
    local scale = location:getScale()

    if "up" == name and scale < max_scale then
      location:scale(0.25)
     
    elseif "down" == name and scale > min_scale then
      location:scale(-0.25)

    elseif "up" == name then -- zoom into location if viewing map
    elseif "down" == name then -- zoom into map if viewing location
      local scene = composer.getSceneName('current')
      composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.map', options)
    end
  end
end

local function movePlatform(event)
    local platformTouched = event.target
    if (event.phase == "began") then
        display.getCurrentStage():setFocus( platformTouched )

        -- here the first position is stored in x and y         
        platformTouched.startMoveX = platformTouched.x
        platformTouched.startMoveY = platformTouched.y 
    elseif (event.phase == "moved") then
        -- here the distance is calculated between the start of the movement and its current position of the drag  
        local x_pos = (event.x - event.xStart) + platformTouched.startMoveX
        local y_pos = (event.y - event.yStart) + platformTouched.startMoveY

        platformTouched.x =  x_pos 
        platformTouched.y = y_pos    
    elseif event.phase == "ended" or event.phase == "cancelled"  then
        -- here the focus is removed from the last position
        display.getCurrentStage():setFocus( nil )
    end
    return true
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).   
     
        Runtime:addEventListener("key", zooming)  
        location:addEventListener( "touch", movePlatform )
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view

    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.     
        Runtime:removeEventListener( "key", zooming )
    end  
end


-- "scene:destroy()"
function scene:destroy( event )

    location:destroy()  
    Runtime:removeEventListener( "key", zooming )     

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene