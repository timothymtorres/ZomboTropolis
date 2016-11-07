-----------------------------------------------------------------------------------------
--
-- skills.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require("composer")
local skill_list = require('code.player.skills.list')
local mob_type = main_player:getMobType()

local imageSheet = {
  human = {
    classes = {info = require('graphics.icons.skills.human.classes@1x'),},
    general = {info = require('graphics.icons.skills.human.general@1x'),},
    military = {info = require('graphics.icons.skills.human.military@1x'),},
    medical = {info = require('graphics.icons.skills.human.medical@1x'),},
    research = {info = require('graphics.icons.skills.human.research@1x'),},
    engineering = {info = require('graphics.icons.skills.human.engineering@1x'),},
  },
  zombie = {
    classes = {info = require('graphics.icons.skills.zombie.classes@1x'),},
    general = {info = require('graphics.icons.skills.zombie.general@1x'),},
    brute = {info = require('graphics.icons.skills.zombie.brute@1x'),},
    hunter = {info = require('graphics.icons.skills.zombie.hunter@1x'),},
    sentient = {info = require('graphics.icons.skills.zombie.sentient@1x'),},
    hive = {info = require('graphics.icons.skills.zombie.hive@1x'),},        
  },
}

for category in pairs(imageSheet[mob_type]) do
  local sheet = imageSheet[mob_type][category].info:getSheet()
  imageSheet[mob_type][category].png = graphics.newImageSheet('graphics/icons/skills/'..mob_type..'/'..category..'@1x.png', sheet)
end

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
--[[
local imagesheets = {}

imagesheets.classes = {}
imagesheets.classes.info = require("graphics.icons.classes")
imagesheets.classes.png = graphics.newImageSheet( "graphics/icons/classes.png", imagesheets.classes.info:getSheet())
    --local skill_image = display.newImage(imagesheets[category].png, imagesheets[category].info:getFrameIndex(skill_data.icon))

      local button1 = widget.newButton
      {
          sheet = imagesheets[category].png,
          defaultFrame = skill_data.icon,
          overFrame = skill_data.icon:setFillColor(0.5, 0.5, 0.5, 0.25),
          label = "button",
          onEvent = handleButtonEvent
      }
--]]

local options = {
   isModal = true,
   effect = "fade",
   time = 400,
   params = {
      sampleVar = "my sample variable"
   }
}

-- ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end

    return true
end


local icon_size, offset, padding, divider = 64, 30, 10, 8
local button_color 
-- -------------------------------------------------------------------------------

local function canPurchaseSkill(skill, check_xp)  
  local player_mob_type = main_player:getMobType()
  local xp = main_player:getStat('xp')
  
  local class = skill_list.isClass(skill)  
  local cost = (class and main_player.skills:getCost('classes') ) or main_player.skills:getCost('skills')  
  local required_flags = skill_list.getRequiredFlags(skill)
  local skill_mob_type = skill_list.getMobType(skill) 

  if check_xp == 'with xp' then 
    check_xp = xp >= cost  -- Enough Xp?
  elseif check_xp == 'without xp' then  -- No need to check xp cost
    check_xp = true
  end
  
  if check_xp and
  skill_mob_type == player_mob_type and  -- Player mob type must match skill
  main_player:isStanding() and  -- Player must be standing
  not (main_player.skills:check(skill))  -- Skill must not have already been purchased 
  then
    for category, flags in pairs(required_flags) do  -- Have all required skills
      if not (flags == 0 or main_player.skills:checkFlag(category, flags)) then return false end
    end    
    return true
  else
    return false
  end  
end

local function getButtonColor(skill)
  if main_player.skills:check(skill) then return {0.8, 0.8, 0, 1}
  elseif canPurchaseSkill(skill, 'with xp') then return {0, 0.8, 0, 1}
  elseif canPurchaseSkill(skill, 'without xp') then return {0, 0.8, 0.8, 1} -- have all required skills, but not enough xp
  else return {0.8, 0, 0, 1} -- cannot purchase skill
  end  
end

local function getButtonCategoryColor(skill)
  local category = (skill_list.getCategory(skill) == 'classes' and skill) or skill_list.getCategory(skill)
  if category == 'general' then return {1, 1, 1, 1}
  elseif category == 'military' then return {1, 0, 0, 1}
  elseif category == 'medical' then return {0, 0, 1, 1}
  elseif category == 'research' then return {0, 1, 0, 1}
  elseif category == 'engineering' then return {1, 1, 0, 1}
  end  
end
 
local skill_buttons, categoryText, scrollView = {}, {}

-- THIS IS TEMPORARY!!!
local function handleButtonEvent( event )
    skill_buttons[event.target.id]:setFillColor(unpack(getButtonColor(event.target.id)))
    
    if ( "ended" == event.phase ) then      
        local skill, params = skill_list[event.target.id], options.params
        params.id = event.target.id
        params.name = skill.name
        params.desc = skill.desc
        params.requires = skill.requires
        params.icon = skill.icon
        
        composer.showOverlay( "scenes.skill_purchase", options )        
        print( "Button was pressed and released" )
    end
end  

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view   
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.     
  
  -- Create the widget
  scrollView = widget.newScrollView
  {
      top = 10,
      left = 10,
      width = 300,
      height = 400,
      scrollWidth = 300,
      scrollHeight = 400,
      listener = scrollListener,
      backgroundColor = {0.5, 0.5, 0.5, 1}
  }
  sceneGroup:insert(scrollView)
  
  local num = 0

  for i, category in ipairs(skill_list.order[mob_type].category) do
    num = num + 1  -- vary the amount because category ~= icon_size
    local row = 0
    
    local purchasedChoices, maxChoices = main_player.skills:countFlags(category), #skill_list.order[mob_type][category]
    local str = "--"..category.."-- ["..purchasedChoices..'/'..maxChoices..']'
    categoryText[category] = {} 
    categoryText[category].info = {text=str, x=offset + 70, y=offset + icon_size*(num) + divider*(num) + icon_size*0.5 + divider*0.5, font=native.systemFont, font_size=32, fillColor = {1, 0, 0}} 
    
    local message = categoryText[category].info
    local category_title_text = display.newText(message.text, message.x, message.y, message.font, message.font_size)
    category_title_text:setFillColor(unpack(message.fillColor))  
  
    categoryText[category].button = category_title_text
    scrollView:insert(category_title_text)
 
    for ii, skill in ipairs(skill_list.order[mob_type][category]) do      
      if row == 0 then num = num + 1 end
      
      local skill_data = skill_list.info[mob_type][category][skill]
      --local category = skill_list.getCategory(skill)
      local sheetInfo = imageSheet[mob_type][category].info
      local icon
      
      if skill_data.icon then icon = sheetInfo:getFrameIndex(skill_data.icon) end
      
      local button = widget.newButton
      {
          left = padding + icon_size*(row) - icon_size*0.5 + divider*(row),
          top = offset + icon_size*num - icon_size*0.5 + divider*num,
          id = skill,
      --  label = skill_data.name,
          onEvent = handleButtonEvent,
          
          -- is this neccessary now?
          --shape = (icon or nil) or 'rect',          
          width = icon_size,
          height = icon_size,         
          strokeColor = { default=getButtonCategoryColor(skill), over={ 0.8, 0.8, 1, 1 } },     
          strokeWidth = 4,                      
          --]]-- is this neccessary now?
 
          fillColor = { default=getButtonColor(skill), over={ 1, 0.1, 0.7, 0.4 } },    
          sheet = imageSheet[mob_type][category].png,
          defaultFrame = icon or 1,
          overFrame = icon or 1,
      }  
      skill_buttons[skill] = button
      
      -- Change the button's label text
      button:setLabel(skill_data.name)     
      button:scale(0.5, 0.5)

    --  skill_data.tier
      scrollView:insert( button )    
      
      if row == 0 then row = row + 1
      elseif row == 3 then row = 0
      else row = row + 1
      end      
    end
  end  
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        for i, category in ipairs(skill_list.order[mob_type].category) do          
          categoryText[category].button:removeSelf()
          categoryText[category].button = nil
          
          local purchasedChoices, maxChoices = main_player.skills:countFlags(category), #skill_list.order[mob_type][category]
          local str = "--"..category.."-- ["..purchasedChoices..'/'..maxChoices..']'          
          categoryText[category].info.text = str 
          local message = categoryText[category].info
          local category_title_text = display.newText(message.text, message.x, message.y, message.font, message.font_size)
          category_title_text:setFillColor(unpack(message.fillColor))  
        
          categoryText[category].button = category_title_text
          scrollView:insert(category_title_text)          
        
          for ii, skill in ipairs(skill_list.order[mob_type][category]) do       
            skill_buttons[skill]:setFillColor(unpack(getButtonColor(skill)))
          end     
        end  
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