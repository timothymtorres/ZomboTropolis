-----------------------------------------------------------------------------------------
--
-- skill_purchase.lua
--
-----------------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()
local widget = require('widget')
local mob_type = main_player:getMobType()

local skill_list = {}
skill_list.zombie = require('code.player.zombie.skill_list')
skill_list.human = require('code.player.human.skill_list')

local imageSheet = {
  human = {
    classes = {info = require('graphics.icons.skills.human.classes@1x'),},
    general = {info = require('graphics.icons.skills.human.general@1x'),},
    military = {info = require('graphics.icons.skills.human.military@1x'),},
    research = {info = require('graphics.icons.skills.human.research@1x'),},
    engineering = {info = require('graphics.icons.skills.human.engineering@1x'),},
  },
  zombie = {
    classes = {info = require('graphics.icons.skills.zombie.classes@1x'),},
    general = {info = require('graphics.icons.skills.zombie.general@1x'),},
    brute = {info = require('graphics.icons.skills.zombie.brute@1x'),},
    hunter = {info = require('graphics.icons.skills.zombie.hunter@1x'),},
    hive = {info = require('graphics.icons.skills.zombie.hive@1x'),},        
  },
}

for category in pairs(imageSheet[mob_type]) do
  local sheet = imageSheet[mob_type][category].info:getSheet()
  imageSheet[mob_type][category].png = graphics.newImageSheet('graphics/icons/skills/'..mob_type..'/'..category..'@1x.png', sheet)
end


---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

local container_w, container_h = 250, 300
local icon_size = 128  -- enlarged 
local button_w, button_h, divider = 100, 40, 10

local cancelButtonEvent = function(event)
  if ('ended' == event.phase) then
    print('Button was pressed and released')
    composer.hideOverlay('fade', 400)
  end
end
   
local function titleCaseHelper(first, rest)
  return first:upper()..rest:lower()  
end    

local function canPurchaseSkill(skill) 
  local xp = main_player.stats:get('xp')
  
  local class = skill_list[mob_type]:isClass(skill)  
  local cost = (class and main_player.skills:getCost('classes') ) or main_player.skills:getCost('skills')  
  local required_flags = skill_list[mob_type]:getRequiredFlags(skill) 
  
  if (xp >= cost) and main_player:isStanding() and not (main_player.skills:check(skill)) then
    for category, flags in pairs(required_flags) do -- Have all required skills
      if not (flags == 0 or main_player.skills:checkFlag(category, flags)) then return false end
    end    
    return true
  else
    return false
  end  
end

local function getButtonColor(button_ID)
  if canPurchaseSkill(button_ID) then return { 1, 0, 0, 1 }
  else return {.5, .5, .5, .75}
  end
end
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
   local sceneGroup = self.view
   local parent = event.parent
   local params = event.params

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local bar_h = 30
    local container = display.newContainer( container_w, container_h + bar_h)
    -- TAB BAR HEIGHT = 60  (so 480-60 /2)
    container:translate( 160, 210 + bar_h*0.5 ) -- center the container

    container_h = container_h - bar_h*0.5
    local background = display.newRect(0, 0, container_w, container_h)
    background:setFillColor(0.1, 0.1, 0.1, 0.70)
    container:insert(background)    
    
    local top_background_bar = display.newRect(0, -1*(container_h/2 + bar_h*0.5), container_w, bar_h) 
    top_background_bar:setFillColor(1, 1, 1, 0.70)
    container:insert(top_background_bar)
    
    local cost = (skill_list[mob_type]:isClass(params.id) and main_player.skills:getCost('classes')) or main_player.skills:getCost('skills')
    local next_skill_cost = display.newText{
      text = 'Purchase Skill For: '..cost..' XP', 
      x = 0, 
      y = -1*(container_h/2 + bar_h*0.375), 
      font = native.systemFont, 
      fontSize = 14,
    }
    next_skill_cost:setFillColor(1, 0, 0, 1)
    container:insert(next_skill_cost)     
    
    local icon

    if params.icon then
      local category = skill_list[mob_type]:getCategory(params.id)
      icon = display.newImage(imageSheet[mob_type][category].png, imageSheet[mob_type][category].info:getFrameIndex(params.icon))
      icon.x, icon.y = 0, -1*(container_h/6)
    else
      print('uhh huh?  why is this working?')
      icon = display.newRect(0, -1*(container_h/6), icon_size, icon_size)      
    end
    --icon:setFillColor(0, 0, 0)
    container:insert(icon)
    
    local title = params.name:gsub("(%a)([%w_']*)", titleCaseHelper)
    local skill_title = display.newText(title, 0, -130, native.systemFont, 20)
    skill_title:setFillColor( 0, 1, 0 )
    container:insert(skill_title)        
   
    local skill_critera = skill_list[mob_type]:getRequirement(params.id, 'skills')
    local class_critera = skill_list[mob_type]:getRequirement(params.id, 'class')
    
    local divider_h, icon_size = 8, 32    
    
    if skill_critera then      
      local require_skill_text = display.newText( "REQUIRED", -1*(container_w/3 +10), -100, native.systemFont, 8)
      require_skill_text:setFillColor( 1, 1, 0 )
      container:insert(require_skill_text)
      
      for i,skill in ipairs(skill_critera) do
--[[      
local imageSheet = {classes = {info = require('graphics.icons.skills.human.classes@1x'),}, }

for category in pairs(imageSheet) do
  local sheet = imageSheet[category].info:getSheet()
  imageSheet[category].png = graphics.newImageSheet('graphics/icons/skills/human/'..category..'@1x.png', sheet)
end      

      local category = skill_list[mob_type]:getCategory(params.id)
      icon = display.newImage(imageSheet[category].png, imageSheet[category].info:getFrameIndex(params.icon))
--]]     
        local skill_icon = skill_list[mob_type][skill].icon
        if skill_icon then
          local category = skill_list[mob_type]:getCategory(skill)
          skill_icon = display.newImage(imageSheet[mob_type][category].png, imageSheet[mob_type][category].info:getFrameIndex(skill_icon))
          skill_icon.x, skill_icon.y = -1*(container_w/3 + 10), -75+(icon_size*(i-1))+(divider_h*(i-1))       
          skill_icon:scale(0.25, 0.25)            
        else
          skill_icon = display.newRect(-1*(container_w/3 + 10), -75+(icon_size*(i-1))+(divider_h*(i-1)), icon_size, icon_size)
        end
        container:insert(skill_icon)
      end
    end
    
    if class_critera then
      local require_class_text = display.newText( "REQUIRED", (container_w/3 +10), -100, native.systemFont, 8)
      require_class_text:setFillColor( 1, 1, 0 )
      container:insert(require_class_text)

      local category = skill_list[mob_type]:getCategory(class_critera)
      local class_icon = skill_list[mob_type][class_critera].icon
      class_icon = display.newImage(imageSheet[mob_type][category].png, imageSheet[mob_type][category].info:getFrameIndex(class_icon))
      class_icon.x, class_icon.y = (container_w/3 + 10), -75            
      class_icon:scale(0.25, 0.25)
      container:insert(class_icon)      
    end

    local desc_options = 
    {
        text = params.desc,     
        x = 0,
        y = 30,
        width = container_w-10,
        font = native.systemFont,   
        fontSize = 10,
        align = "center"
    }

    local desc_text = display.newText(desc_options)
    desc_text:setFillColor(1, 1, 1)
    container:insert(desc_text)

    local buyButtonEvent = function(event)
      if ('ended' == event.phase) then
        main_player.skills:buy(main_player, params.id)
        composer.hideOverlay('fade', 400)       
        composer.gotoScene('scenes.skills')
        print('Button was pressed and released')
      end
    end

    local buy_button = widget.newButton
      {
          left = -1*(button_w + divider),
          top = container_h/3,
      --  id = ,
          label = 'BUY',
          isEnabled = canPurchaseSkill(params.id),
          onEvent = buyButtonEvent,
          shape = 'rect',
          width = button_w,
          height = button_h,
          fillColor = { default=getButtonColor(params.id), over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }  
    container:insert(buy_button) -- insert and center text

    local cancel_button = widget.newButton
      {
          left = divider,
          top = container_h/3,
      --  id = ,
          label = 'CANCEL',
          onEvent = cancelButtonEvent,
          shape = 'rect',
          width = button_w,
          height = button_h,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 4      
      }  
    container:insert(cancel_button) -- insert and center text
    
    sceneGroup:insert(container)
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

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene