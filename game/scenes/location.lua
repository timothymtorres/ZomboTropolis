-----------------------------------------------------------------------------------------
--
-- location.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local berry = require( 'code.libs.berry' )
local lume = require('code.libs.lume')
local createMob = require('scenes.functions.createMob')
local Tiles = require('code.location.tile.tiles')

local location

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local player_stage = main_player:getStage()
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view

  -- start physics
  physics.start() 
  physics.setGravity(0, 0)
  physics.setDrawMode("hybrid")

  -- Load our location
  local y, x = main_player:getPos()

print('world var is?', world)
  local tile_gid = world:getGID('Location Template ID', y, x)
  local template_name = 'default' --world.cache.properties[tile_gid].template
  local filename = "graphics/locations/"..template_name.. ".json"

  location = berry:new( filename, "graphics/locations/")
  location:addTexturePack("graphics/items.png", "graphics.items.lua")

  -- Create our extra layers for dynamic objects
  location:addLayer("Corpse")
  location:addLayer("Mob")
  location:addLayer("Item")

  location:setExtension("scenes.objects.")
  location:extend("door", "barricade")  -- entrance
  location:extend("apc", "terminal", "generator", "transmitter") -- equipment
  location:extend("seperator") -- physics dividers to keep humans/zombies apart
  location:extend("search_area")

  local player_location = main_player:getLocation()

  -- setup spawn locations
  local defender_spawns = { 
      location:getObjects( {name=player_stage, type='defender'} ) 
    }
  local attacker_spawns = { 
      location:getObjects( {name=player_stage, type='attacker'} ) 
    }

  -- both attacker/defender spawns combined
  local location_spawns = lume.merge(defender_spawns, attacker_spawns)

  local attacker = player_location:getAttacker(player_stage)
  local defender = player_location:getDefender(player_stage)
  local is_location_contested = player_location:isContested(player_stage)

  -- enable/disable physics walls that seperates attacker/defenders 
  local dividers = {
      location:getObjects( {name=player_stage, type='seperator'} )
  }
  for _, divider in ipairs(dividers) do
    divider:toggle(is_location_contested)
  end

  -- spawn mobs onto map
  local mobs = player_location:getPlayers(player_stage) 
  for player in pairs(mobs) do
    if not player.status_effect:isActive('hide') then
      local spawns 
      if is_location_contested then          
        if player:isMobType(attacker) then spawns = attacker_spawns  
        elseif player:isMobType(defender) then spawns = defender_spawns
        end
      else spawns = location_spawns -- both attacker/defender spawns
      end

      local spawn = lume.randomchoice(spawns)

      local mob = createMob(player, location)
      mob.x, mob.y =  spawn.x, spawn.y
    end
  end

  if main_player:isStaged('inside') then
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
      door.isVisible = is_door_present
      door:setFrame( player_location.door:getHP() + 1 )
    end

    -- display our barricades
    local barricades = { location:getObjects( {type='barricade'} ) }
    local is_cade_present = player_location:isPresent('barricade')
    for _, barricade in ipairs(barricades) do
      barricade.isVisible = is_cade_present
      barricade:setFrame( player_location.barricade:getState() )
    end
  end

  local tile_name = tostring(main_player:getLocation())

  local v_border, h_border = 3, 16

  local name_options = {
    text = tile_name,
    font = native.systemFont,
    fontSize = 9,
    align = 'center',
    x = display.contentWidth*0.50,
    y = display.contentHeight*0.12,
  }

  local location_name = display.newText(name_options)
  location_name:setFillColor(0.15, 0.15, 0.15, 1)

  local x, y = location_name.x, location_name.y
  local w, h = location_name.contentWidth + h_border, name_options.fontSize + v_border*2 
  local corner = h/4

  local location_name_background = display.newRoundedRect(x, y, w, h, corner)
  location_name_background:setFillColor(0.85, 0.85, 0.85, 1)

  sceneGroup:insert(location)
  sceneGroup:insert(location_name_background)
  sceneGroup:insert(location_name)

  return sceneGroup
end

local MAX_SCALE, MIN_SCALE = 4, 0.5

local function zooming( event )
  local phase = event.phase
  local name = event.keyName

  local SCALE_INCREMENT = 0.50

  if phase == "down" then
--[[ if "up" == name and location.xScale < MAX_SCALE then  -- zoom in
      transition.scaleBy(location, { xScale=1+SCALE_INCREMENT, yScale=1+SCALE_INCREMENT, time=2000 } )
    elseif "down" == name and location.xScale > MIN_SCALE then -- zoom out
      transition.scaleBy(location, { xScale=0.25, yScale=0.25, time=2000 } )
    elseif "up" == name then -- zoom into world if viewing map  
--]]
    if "down" == name then -- zoom into map if viewing room
      local scene = composer.getSceneName('current')
      composer.removeScene(scene)      

      local options = {effect = "fade", time = 500,}   
      composer.gotoScene('scenes.map', options)   
    end
  end

print("Location Scale: ", location.xScale, location.yScale)
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
        local mobs = { location:getObjects( {type='mob'} ) }
        for _, mob in ipairs(mobs) do 
          timer.pause(mob.movement_timer) 
        end
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.     
        Runtime:removeEventListener( "key", zooming )
    end  
end


-- "scene:destroy()"
function scene:destroy( event )

    --location:destroy()  
    Runtime:removeEventListener( "key", zooming ) 
    physics.stop()    

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.

    -- Do we really need to cancel timers on scene:destroy?
    local mobs = { location:getObjects( {type='mob'} ) }
    for _, mob in ipairs(mobs) do 
      timer.cancel(mob.movement_timer) 
    end
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene