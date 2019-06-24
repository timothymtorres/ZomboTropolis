local widget = require("widget")
local composer = require( "composer" )
local names = require('code.player.names.names')

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local width, height = display.contentWidth, display.contentHeight

local sex_type, mob_type = 'male', 'human'
local name, name_text

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc. 
 
  local title_options = {
      text = "ZomboTropolis",     
      x = width*0.5,
      y = height*0.25,
      font = native.systemFontBold,   
      fontSize = 40,
      align = "center"
  }

  local title = display.newText(title_options)
  title:setFillColor(0.1, 0.9, 0.5, 1)

  local title_background = display.newRect(0, 0, title.contentWidth + 50, title.contentHeight + 20)
  title_background.x, title_background.y = width*0.5, height*0.25
  title_background:setFillColor(0.85, 0.1, 0)

  sceneGroup:insert(title_background)
  sceneGroup:insert(title)

  local function sexChange(event) 
    sex_type = event.target.id 
    name = names:generateRandom((mob_type == 'zombie' and mob_type) or sex_type)
    name_text.text = "Generated Name: ".. name
  end

  local sex_group = display.newGroup()
  local sex_y = height*0.43
  local sex_x = width*0.50

  local male_button = widget.newSwitch{
    x = sex_x - width*0.18,
    y = sex_y,
    style = "radio",
    id = "male",
    initialSwitchState = true,
    onPress = sexChange,
  }

  local female_button = widget.newSwitch{
    x = sex_x + width*0.18,
    y = sex_y,
    style = "radio",
    id = "female",
    onPress = sexChange,
  }
  sex_group:insert(male_button)
  sex_group:insert(female_button)

  local sex_options = display.newText("Male | Female", sex_x, sex_y, 
                                        native.systemFont, 16)

  sceneGroup:insert(sex_group)
  sceneGroup:insert(sex_options)

  local function mobChange(event) 
    mob_type = event.target.id 
    name = names:generateRandom((mob_type == 'zombie' and mob_type) or sex_type)
    name_text.text = "Generated Name: ".. name
  end

  local mob_group = display.newGroup()
  local mob_y = height*0.55
  local mob_x = width*0.50

  local human_button = widget.newSwitch{
    x = mob_x - width*0.18,
    y = mob_y,
    style = "radio",
    id = "human",
    initialSwitchState = true,
    onPress = mobChange,
  }

  local zombie_button = widget.newSwitch{
    x = mob_x + width*0.18,
    y = mob_y,
    style = "radio",
    id = "zombie",
    onPress = mobChange,
  }
  mob_group:insert(human_button)
  mob_group:insert(zombie_button)

  local mob_options = display.newText("Human | Zombie", mob_x, mob_y, 
                                        native.systemFont, 16)

  sceneGroup:insert(mob_group)
  sceneGroup:insert(mob_options)

  name = names:generateRandom((mob_type == 'zombie' and mob_type) or sex_type)
  name_text = display.newText("Generated Name: ".. name, 
                               width*0.5, height*0.65, native.systemFont, 20)
  sceneGroup:insert(name_text)

  local function startGame()
    local options ={
      isModal = true,
      effect = "fade",
      time = 400,
      params = {
        mob_type = mob_type,
      }
    }
    composer.showOverlay( "scenes.overlays.character_cosmetics", options )
  end

  local start_button = widget.newButton{
    x= width*0.5,
    y= height*0.80,
    label = "Start Game",
    onPress = startGame,
    shape = "roundedRect",
    width = 150,
    height = 40,
    cornerRadius = 2,
    fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
    strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
    strokeWidth = 4
  }

  sceneGroup:insert(start_button)

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
      composer.removeScene( "scenes.main_menu" )  
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