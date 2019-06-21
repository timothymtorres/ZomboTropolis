local composer = require("composer")
local widget = require("widget")
local loadMobTilesets = require('scenes.functions.loadMobTilesets')
local loadClothing = require('scenes.functions.loadClothing')
local lume = require('code.libs.lume')

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------

local tilesets = loadMobTilesets('graphics/mob')
local clothing = loadClothing('graphics/mob')

local width, height = display.contentWidth, display.contentHeight --320, 428
local container_w, container_h = math.floor(width*0.875 + 0.5), math.floor(height*0.80 + 0.5)
local container_left = -1 * math.floor(container_w*0.5 + 0.5)
local container_top = -1 * math.floor(container_h*0.5 + 0.5)

local container 
local mob_sprites = {}  -- this holds the 4 mob display objects in each direction
local cosmetic_segment, mob_cosmetics
local scrollView

local function drawMob(options)
  local mob_size = 64
  -- 4 mobs divided by 5 equal sized gaps
  local mob_divider = (container_w - (mob_size*4))/5
  local directions = {'north', 'east', 'south', 'west'} 

  if not options then
    options = {}

    if main_player:isMobType("zombie") then options.body = "red_orc"
    else options.body = "light" -- regular human 
    end
  end

  for i=1, 4 do
    mob = display.newGroup()

    local mob_background = display.newRect(0, 0, mob_size, mob_size)
    mob_background:setFillColor(0.9, 0.9, 0.9, 1)
    mob:insert(mob_background)

    local body = display.newSprite(tilesets[options.body].sheet, tilesets[options.body])
    mob:insert(body)

    if options.hair then
      local hair = display.newSprite(tilesets[options.hair].sheet, tilesets[options.hair])
      mob:insert(hair)
    end

    -- eyes should just change color.... and be setup default? like body

    if options.torso then
      local torso = display.newSprite(tilesets[options.torso].sheet, tilesets[options.torso])
      mob:insert(torso)
    end

    local dir = directions[i]
    local animation = "walk-" ..dir
    for i=2, mob.numChildren do 
      mob[i]:setSequence(animation) 
      mob[i]:play()
    end 

    mob.x = container_left  + (i*mob_divider) + ( (i-1)*mob_size) + mob_size/2
    mob.y = container_top + container_h*0.15
    mob.anchorX = 0

    if mob_sprites[dir] then mob_sprites[dir]:removeSelf() end
    mob_sprites[dir] = mob
  end

  return options
end


local function drawCosmeticOptions(category)

  -- currently there is a bug with the radio button that disables buttons on the
  -- bottom row when you click on them and click the top row... not sure why?

  -- Create a group for the radio button set
  local radioGroup = display.newGroup()
  local nameGroup = display.newGroup()

  -- Handle press events for the buttons
  local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )

    local current_category = string.lower(cosmetic_segment.segmentLabel)
    mob_cosmetics[current_category] = switch.id ~= 'none' and switch.id or nil
    mob_cosmetics = drawMob(mob_cosmetics)
    for _, sprite in pairs(mob_sprites) do container:insert(sprite) end
  end

  for i, cosmetic_option in ipairs(clothing[category]) do
    local radio_y = math.floor( (i-1)/3) * container_h*0.30 + container_h*0.15
    local radio_x = ( (i-1)%3) * container_w*0.20 + container_w*0.12

    local is_cosmetic_selected = (cosmetic_option == mob_cosmetics[category]) or
                                 (cosmetic_option == 'none' and not mob_cosmetics[category]) 

    local cosmetic_radio_button = widget.newSwitch{
      x = radio_x,
      y = radio_y,
      style = "radio",
      id = cosmetic_option,
      initialSwitchState = is_cosmetic_selected,
      onRelease = onSwitchPress
    }
    radioGroup:insert(cosmetic_radio_button)

    local cosmetic_name = display.newText(cosmetic_option, radio_x, radio_y - 30, 
                                          native.systemFont, 10)
    nameGroup:insert(cosmetic_name)
  end

  return radioGroup, nameGroup
end

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local mob = event.params and event.params.mob -- the mob display object
  
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
  container = display.newContainer( container_w, container_h)  
  container:translate( width*0.5, height*0.5 ) -- center the container

  local background = display.newRect(0, 0, container_w, container_h)
  background:setFillColor(0.1, 0.1, 0.1, 0.85)
  container:insert(background)

  mob_cosmetics = drawMob()
  for _, sprite in pairs(mob_sprites) do container:insert(sprite) end

  -- Listen for segmented control events      
  local function onSegmentPress( event )
    local target = event.target
    print( "Segment Label is:", target.segmentLabel )
    print( "Segment Number is:", target.segmentNumber )

    cosmetic_group:removeSelf()
    name_group:removeSelf()

    category = string.lower(cosmetic_segment.segmentLabel)
    cosmetic_group, name_group = drawCosmeticOptions(category)

    scrollView:insert(cosmetic_group)
    scrollView:insert(name_group)
  end

  local cosmetic_choices = {"Body", "Hair", "Torso"} -- Beard
  local segment_total_width = container_w*0.90

  -- Create a default segmented control
  cosmetic_segment = widget.newSegmentedControl(
    {
        segmentWidth = segment_total_width/#cosmetic_choices,
        segments = cosmetic_choices,
        onPress = onSegmentPress
    }
  )
  cosmetic_segment.x = 0
  cosmetic_segment.y = container_top + container_h*0.35

  container:insert(cosmetic_segment)

  -- Create the widget
  scrollView = widget.newScrollView{
    width = container_w * 0.64,
    height = container_h * 0.50,
    --horizontalScrollDisabled = true,
    backgroundColor = {0.5, 0.5, 0.5, 1},
    topPadding = 10,
    bottomPadding = 20,
  }

  --scrollView:setScrollHeight(scrollView._view._scrollHeight + 50)
  scrollView.x = container_left + container_w * 0.36
  scrollView.y = container_top + container_h * 0.70

  for category in pairs(clothing) do
    -- inserts bald/blank/naked option for everything but body 
    if category ~= 'body' and not lume.find(clothing[category], 'none') then
      table.insert(clothing[category], 1, 'none') 
    end

    -- whatever the mob is currently wearing becomes the first option 
    if mob_cosmetics[category] then -- if wearing nothing then skip this
      local currently_worn = lume.remove(clothing[category], mob_cosmetics[category])
      table.insert(clothing[category], 1, currently_worn)
    end
  end

  local category = string.lower(cosmetic_segment.segmentLabel)
  cosmetic_group, name_group = drawCosmeticOptions(category)
  scrollView:insert(cosmetic_group)
  scrollView:insert(name_group)

  container:insert(scrollView)



  -- IF CHARACTER CREATION HAPPENING - NO CANCEL BUTTON SHOULD EXIST

  local function cancelOverlay(event)
    print('button pressed and released')
    --composer.hideOverlay('fade', 400)       
  end

  -- Create the widget
  local cancel = widget.newButton(
      {
          label = "Cancel",
          onRelease = cancelOverlay,
          shape = "roundedRect",
          width = container_w*0.25,
          height = container_h*0.20,
          cornerRadius = 5, -- this is hardcoded bc I'm lazy
      }
  )

  cancel.x = container_left + container_w*0.85
  cancel.y = container_top + container_h*0.57

  container:insert(cancel)

  local function accept(event)
    print('button pressed and released')
  end

  -- Create the widget
  local accept = widget.newButton(
      {
          label = "Accept",
          onRelease = accept,
          shape = "roundedRect",
          width = container_w*0.25,
          height = container_h*0.20,
          cornerRadius = 5, -- this is hardcoded bc I'm lazy
      }
  )

  accept.x = container_left + container_w*0.85
  accept.y = container_top + container_h*0.84

  container:insert(accept)

  --sceneGroup:insert(container)  shouldn't this be activated?!
end


-- "scene:show()"
function scene:show( event )
  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Called when the scene is still off screen (but is about to come on screen).
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
  end
end


-- "scene:destroy()"
function scene:destroy( event )
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