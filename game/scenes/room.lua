-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
berry = require( 'code.libs.berry.berry' )
local json = require( "json" )
local room

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

--[[ ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if (event.limitReached) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end

    return true
end
--]]

local width, height = display.contentWidth, display.contentHeight -- 320x480
local widget = require('widget')

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  -- Load our map
  local filename = "graphics/map/room/ZTRoom.json"
  room = berry.loadMap( filename, "graphics/map/room" )
  local visual = berry.createVisual( room )
  berry.buildPhysical( room )

  return sceneGroup
end

--[[
-- Function to scroll the map
local function enterFrame( event )

  local elapsed = event.time

  -- Easy way to scroll a map based on a character
  if hero and hero.x and hero.y and not hero.isDead then
    local x, y = hero:localToContent( 0, 0 )
    x, y = display.contentCenterX - x, display.contentCenterY - y  -- this centers hero on the screen always
    --map.x, map.y = map.x + x, map.y + y
    local visual = map:getVisual()
    visual.x, visual.y = visual.x + x, visual.y + y
  end
end
--]]

local max, acceleration, dy, dx = 375, 5, 0, 0, 0, 0
local lastEvent = {}
local function key( event )
  local phase = event.phase
  local name = event.keyName
  --if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys
  if phase == "down" then
    if "left" == name or "a" == name then dx = -acceleration end
    if "right" == name or "d" == name then dx = acceleration end
    if "up" == name or "w" == name then dy = -acceleration end
    if "down" == name or "s" == name then dy= acceleration end

    local visual = room:getVisual()

    room:move (dx, dy)    
    --visual.x = visual.x + dx
    --visual.y = visual.y + dy

    --dx, dy = 0, 0    
  end
  lastEvent = event
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
        platformTouched.x = (event.x - event.xStart) + platformTouched.startMoveX
        platformTouched.y = (event.y - event.yStart) + platformTouched.startMoveY
    elseif event.phase == "ended" or event.phase == "cancelled"  then
        -- here the focus is removed from the last position
        display.getCurrentStage():setFocus( nil )
    end
    return true
end
 


local function enterFrame()
  -- Do this every frame

--[[
  local visual = room:getVisual()
  visual.x = visual.x + dx
  visual.y = visual.y + dy

  dx, dy = 0, 0
  --]]
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        Runtime:addEventListener( "enterFrame", enterFrame )      
        Runtime:addEventListener("key", key)  
        room.world:addEventListener( "touch", movePlatform )  -- Add a "touch" listener to the object        
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
        Runtime:removeEventListener( "enterFrame", enterFrame )      
        Runtime:removeEventListener( "key", key )          
    end  
end


-- "scene:destroy()"
function scene:destroy( event )

    room:destroy()

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