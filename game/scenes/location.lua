-----------------------------------------------------------------------------------------
--
-- location.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local berry = require( 'code.libs.berry' )
local widget = require('widget')
local lume = require('code.libs.lume')

local location

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local phone_screen_width, phone_screen_height = display.contentWidth, display.contentHeight -- 320x480
local player_stage = main_player:getStage()
local location_timers = {}
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
  local tile_gid = world:getGID('Location Template ID', y, x)
  local template_name = world.cache.properties[tile_gid].template
  local filename = "graphics/locations/"..template_name.. ".json"
  location = berry:new( filename, "graphics/ss13" )

  location:setExtension("scenes.objects.")
  location:extend("door", "barricade")  -- entrance
  location:extend("apc", "terminal", "generator", "transmitter") -- equipment
  location:extend("seperator") -- physics dividers to keep humans/zombies apart

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

  local attacker, defender = player_location:getDominion(player_stage)
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
    local username = player:getUsername()
    local animation = player:getMobType() -- swap this out with sprite_name later
    local is_player_standing = player:isStanding()

    local spawns 
    if is_location_contested then          
      if player:isMobType(attacker) then spawns = attacker_spawns  
      elseif player:isMobType(defender) then spawns = defender_spawns
      end
    else spawns = location_spawns -- both attacker/defender spawns
    end

    local spawn = lume.randomchoice(spawns)

    local mob_data = {
      gid = location:getAnimationGID(animation),
      height = 32,
      width = 32,
      name = username,
      type = "mob",
      isAnimated = true,
    }

    local layer = is_player_standing and "Mob" or "Corpse"
    local mob = location:addObject(mob_data)
    mob:rotate( (is_player_standing and 0) or 90)
    mob.x, mob.y = 0, 0

    local snap_w = 96 --name_background.contentWidth or 32
    local snap_h = 96 --name_background.contentHeight + 32

    local layer_group = location:getLayer("Mob")
    local snap = display.newSnapshot(layer_group, snap_w, snap_h)

    -- used by berry to extend our snapshot
    snap.name, snap.type = username, 'mob'
    snap.player = player
    snap.x, snap.y =  spawn.x, spawn.y

    snap.group:insert( mob )

  end

  location:extend("mob")

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
      local mobs = { location:getObjects( {type='mob'} ) }
      for _, mob in ipairs(mobs) do 
        local total_time = math.random(1250, 1700)
        local username = mob.player:getUsername()
        location_timers[username] = timer.performWithDelay( total_time, mob, -1)
      end
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
          local username = mob.player:getUsername()
          timer.pause(location_timers[username]) 
        end
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

    -- Do we really need to cancel timers on scene:destroy?
    local mobs = { location:getObjects( {type='mob'} ) }
    for _, mob in ipairs(mobs) do 
      local username = mob.player:getUsername()
      timer.cancel(location_timers[username]) 
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