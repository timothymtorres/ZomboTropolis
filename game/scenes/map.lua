-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require('widget')
local berry = require( 'code.libs.berry' )
local json = require( "json" )
local scene = composer.newScene()
local createMob = require('scenes.functions.createMob')


-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- display.contentWidth, display.contentHeight -- 320x480
local grid_square = display.contentHeight*0.15
local grid_x, grid_y = display.contentWidth*0.17, display.contentHeight*0.60

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local move_buttons = display.newGroup()    

  local gridButtonEvent = function(event)
    if ("ended" == event.phase ) then
      local dir = event.target.id
      main_player:perform('move', dir)
      updateMoveButtons()
    end
  end
  
  local centerButtonEvent = function(event)
    if ("ended" == event.phase ) then
      -- event.target.id is one of the following - enter/exit
      main_player:perform(event.target.id)
      updateMoveButtons()
    end
  end 

  local drawMoveButtons = function()
    local map = main_player:getMap()
    local y, x = main_player:getPos()   

    if map[y][x]:isBuilding() then
      local label, id 
      
      -- also this might need to be updated for barricade levels?   
      if main_player:isStaged('inside') then label, id = 'Exit', 'exit'
      elseif main_player:isStaged('outside') then label, id = 'Enter', 'enter'
      end

      local center_grid_button = widget.newButton{
        x = grid_x,
        y = grid_y-grid_square,
        id = id,
        label = label,
        onEvent = centerButtonEvent,
        shape = 'rect',
        width = grid_square,
        height = grid_square,
        fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
        strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
        strokeWidth = 4      
      }

      move_buttons:insert(center_grid_button) 
    end

    local NE_grid_button = widget.newButton{
      x = grid_x+grid_square,
      y = grid_y-grid_square,
      id = 1,
      label = "NE",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local E_grid_button = widget.newButton{
      x = grid_x+grid_square,
      y = grid_y,
      id = 2,
      label = "E",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local SE_grid_button = widget.newButton{
      x = grid_x+grid_square,
      y = grid_y+grid_square,
      id = 3,
      label = "SE",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local S_grid_button = widget.newButton{
      x = grid_x,
      y = grid_y+grid_square,
      id = 4,
      label = "S",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local SW_grid_button = widget.newButton{
      x = grid_x-grid_square,
      y = grid_y+grid_square,
      id = 5,
      label = "SW",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local W_grid_button = widget.newButton{
      x = grid_x-grid_square,
      y = grid_y,
      id = 6,
      label = "W",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local NW_grid_button = widget.newButton{
      x = grid_x-grid_square,
      y = grid_y-grid_square,
      id = 7,
      label = "NW",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    local N_grid_button = widget.newButton{
      x = grid_x,
      y = grid_y-grid_square,
      id = 8,
      label = "N",
      onEvent = gridButtonEvent,
      shape = 'rect',
      width = grid_square,
      height = grid_square,
      fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
      strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
      strokeWidth = 4      
    } 
    -- add our map to the scene
    sceneGroup:insert(grid_3x3_map)  

  end

  function updateMap()
    grid_3x3_map:removeSelf()
    grid_3x3_map = nil
    drawMap()
  end


  -- Load our map
  --local filename = "graphics/map/world.json"
  --world = berry.loadMap( filename, "graphics/map" )
  world.isVisible = true
  world_height, world_width = world.contentHeight, world.contentWidth
  world:scale(2, 2)
  sceneGroup:insert(world)

  world:addLayer("Corpse") -- this may not be neccessary
  world:addLayer("Mob")

  world:setExtension("scenes.objects.")

  local mob = createMob(main_player, world)
  mob:scale(0.25, 0.25)

  local player_y, player_x = main_player:getPos()
  local y, x = world:convertTileToPixel( player_y-1, player_x-1 )
  mob.y, mob.x =  y, x -- centering the mob on the isometric tile

  return sceneGroup
end

-- The zooming in/out is still broken as fuck!
local scale = world.xScale -- both xScale & yScale should be same
local MAX_SCALE, MIN_SCALE = 4, 1
local lastEvent = {}

local function key( event )
  local phase = event.phase
  local name = event.keyName
  --if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys

  local SCALE_INCREMENT = 0.50

  if phase == "down" then
    if "up" == name and scale < MAX_SCALE then
      transition.scaleBy(world, {xScale=SCALE_INCREMENT, yScale=SCALE_INCREMENT, time=2000}) 
    elseif "down" == name and scale > MIN_SCALE then
      transition.scaleBy(world, {xScale=-1*SCALE_INCREMENT, yScale=-1*SCALE_INCREMENT, time=2000})
    elseif "up" == name then -- zoom into world if viewing map
      --local scene = composer.getSceneName('current')
      --composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.location', options)     
    elseif "down" == name then -- zoom into map if viewing room
    end

    scale = world.xScale
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
        local startMoveX = platformTouched.startMoveX or platformTouched.x
        local startMoveY = platformTouched.startMoveY or platformTouched.y

        -- here the distance is calculated between the start of the movement and its current position of the drag  
        local x_pos = (event.x - event.xStart) + startMoveX
        local y_pos = (event.y - event.yStart) + startMoveY

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
    
        Runtime:addEventListener("key", key)  
        world:addEventListener( "touch", movePlatform )  -- Add a "touch" listener to the object        
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
        Runtime:removeEventListener( "key", key )          
    end  
end


-- "scene:destroy()"
function scene:destroy( event )
     
    Runtime:removeEventListener( "key", key )     

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