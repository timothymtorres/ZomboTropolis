-----------------------------------------------------------------------------------------
--
-- action.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )
local action_list = require('code.player.action.list')

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local width, height = display.contentWidth, display.contentHeight -- 320x480
local offset, thickness = 100, 3 

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



local list = {
  location = main_player:getActions('location')
} 

if main_player:isMobType('zombie') then
  list.ability = main_player:getActions('ability')
elseif main_player:isMobType('human') then
  item = main_player:getActions('item')  
end

local menu_w = width - 20
local actionMenu, tabBar, selectedTab, itemListMenu, menu

local function populateItemList()
  menu:insertRow{isCategory=true, params = {name = '[ITEM]', condition = '[CONDITION]', weight = '[SIZE]', canBeTapped=false}}  
  
  for i in ipairs(itemListMenu) do
    local item = itemListMenu[i].item
    menu:insertRow{params = {name = item:getClassName(), condition = item:getConditionState(), weight = item:getWeight(), canBeTapped=true}}
    if itemListMenu[i].collapsed then
      menu:insertRow{params = {name=item:getClassName(), inventory_index=i, discard=true, activate=item:canBeActivated(), canBeTapped=false, item_options=true}}
    end
  end
end

local function onCategoryTap(event)
    local row = event.target
    print("tapped Category", row.id)
for k,v in pairs(itemListMenu) do print(k,v) end
    local id = row.id - 1 -- bc of our top item row category that is omitted
    itemListMenu[id].collapsed = not itemListMenu[id].collapsed
    menu:deleteAllRows()
    populateItemList()
end

local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    
    if row.params.item_options then
      print('')
      print('row.params are:')
      for k,v in pairs(row.params) do print(k,v) end
      
      -- Function to handle button events
      local function handleButtonEvent( event )

          if ( "ended" == event.phase ) then
              print( "Button was pressed and released" )
              local item_name = row.params.name
              print(item_name, 'action cost is - ', main_player:getCost('ap', item_name))
              
              local options = {
                 isModal = true,
                 effect = "fade",
                 time = 400,
                 params = {}
              }             
              
              local mob_type = main_player:getMobType()
              local action_data, params = action_list[mob_type][item_name], options.params
              params.id = action_data.name
              params.inv_id = event.target.id
              params.name = action_data.name
              params.desc = action_data.desc
              params.icon = action_data.icon
              params.cost = main_player:getCost('ap', item_name)
              
              print('')
              print('The params going into options are:')
              for k,v in pairs(options.params) do print(k,v) end
              
              composer.showOverlay("scenes.action.syringe", options) --..item_name, options)
              --composer.showOverlay( "scenes.action_perform", options)        
              print( "Button was pressed and released" )              
          end
      end

      -- Create the widget
      local use_button = widget.newButton
      {
          left = 20,
          top = 0,
          id = row.params.inventory_index,
          label = "Use",
          shape = 'roundedRect',
          height = 40,
          width = 180,
          onEvent = handleButtonEvent
      }   
      use_button:setFillColor(0, 1, 0)
      row:insert(use_button)
    else
      local rowTitle = display.newText( row, row.params.name, 10, 0, nil, 14 )  -- THIS LINE IS IMPORTANT
      rowTitle:setFillColor( 0 )
      rowTitle.anchorX = 0
      rowTitle.y = rowHeight * 0.5
      
      local condition_margin = -80
      local condition_text_options = {
        parent = row,
        text = row.params.condition,     
        x = 0 + condition_margin,
        y = rowHeight * 0.5,
        width = rowWidth,
        fontSize = 14,
        align = "right",
      }
      local rowTitleCondition = display.newText(condition_text_options)
      rowTitleCondition:setFillColor(0.1, 1, 0.1)  
      rowTitleCondition.anchorX = 0
      
      local weight_margin = -10    
      local weight_text_options = {
        parent = row,
        text = row.params.weight,     
        x = 0 + weight_margin,
        y = rowHeight * 0.5,  
        width = rowWidth,
        fontSize = 14,
        align = "right",  
      }
      local rowTitleWeight = display.newText(weight_text_options)  
      rowTitleWeight:setFillColor(0.1, 0.1, 1)  
      rowTitleWeight.anchorX = 0    
      
      if row.params.canBeTapped then
        local categoryBtn = display.newRect( row, 0, 0, row.width, row.height )
        categoryBtn.anchorX, categoryBtn.anchorY = 0, 0
        categoryBtn:addEventListener ( "tap", onCategoryTap )
        categoryBtn.alpha = 0
        categoryBtn.isHitTestable = true
        categoryBtn.id = row.id
      end
    end
end

local function getMenu(menu_type, menu_data)
  --local menu
  
  if menu_type == 'item' then
    menu = widget.newTableView
    {
        top = 80,
        left = 10,
        width = menu_w,
        height = height - 150,
        onRowRender = onRowRender,
      --onRowTouch = onRowTouch,
        isBounceEnabled = false,
        listener = scrollListener
    }

    
    itemListMenu = {}   
    for i, item in ipairs(menu_data) do
      itemListMenu[#itemListMenu+1] = {item = item, collapsed=false}
    end    
    populateItemList()
  else    
    local num, row = 0, 0
    local padding, offset = 10, 20
    local divider_w, divider_h = 20, 15
    --  local icon_size_w, icon_size_h = 90, 40 
    local icon_radius = 40
    local icon_size = icon_radius*2    
    
    menu = widget.newScrollView
    {
        top = 80,
        left = 10,
        width = menu_w,
        height = height - 150,
        scrollWidth = 600,
        scrollHeight = 800,
        listener = scrollListener
    }  
    
    
    local mob_type = main_player:getMobType()
    
    local options = {
       isModal = true,
       effect = "fade",
       time = 400,
       params = {
          sampleVar = "my sample variable"
       }
    }        
    
    for _, action in ipairs(menu_data) do
      if row == 0 then
        num = num + 1
      end       
    
      local buttonEvent = function(event)
        if ("ended" == event.phase ) then
print(event.target.id, 'action cost is - ', main_player:getCost('ap', event.target.id))
          local action_data, params = action_list[mob_type][event.target.id], options.params
          params.id = event.target.id
          params.name = action_data.name
          params.desc = action_data.desc
          params.icon = action_data.icon
          params.cost = main_player:getCost('ap', event.target.id)
          
          composer.showOverlay("scenes.action.syringe", options) --..item_name, options)          
          --composer.showOverlay("scenes.action."..event.target.id, options)    -- this SERIOUSLY needs to be refactored and renamed!!!        
          --composer.showOverlay( "scenes.action_perform", options )        
          print( "Button was pressed and released" )
        end
      end     
    
      local button = widget.newButton
      {
          left = padding + icon_size*(row) + divider_w*(row),
          top = offset + icon_size*num + divider_h*num,
          id = action,
      --  label = skill_data.name,
          onEvent = buttonEvent,
          shape = 'circle',
          radius = icon_radius,
          fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
          strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
          strokeWidth = 3      
      }      
      
      -- Change the button's label text
      button:setLabel(action)              
    --  skill_data.tier
      menu:insert( button )  
      
      if row == 0 then
        row = row + 1
      elseif row == 2 then
        row = 0
      else
        row = row + 1
      end      
    end
  end
  return menu
end 

local function redoMenu(menu_type)
  list[menu_type] = main_player:getActions(menu_type)  
  actionMenu:removeSelf()
  actionMenu = nil
  return getMenu(menu_type, list[menu_type])
end
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  local drawStatBar, stat_bar

  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc.
 
  -- Function to handle button events
  local function handleTabBarEvent( event )
      print('event.target._id ', event.target._id )  --reference to button's 'id' parameter
    selectedTab = event.target._id
    actionMenu = redoMenu(event.target._id)
    sceneGroup:insert(actionMenu)
  end   
 
  -- Configure the tab buttons to appear within the bar
  local tabButtons = {
      {
          label = "Location",
          id = "location",
          selected = true,
          onPress = handleTabBarEvent
      },
  }
  
  if main_player:isMobType('zombie') then
      tabButtons[#tabButtons+1] = {
          label = "Ability",
          id = "ability",
          onPress = handleTabBarEvent
      }    
  elseif main_player:isMobType('human') then
      tabButtons[#tabButtons+1] = {  
          label = "Item",
          id = "item",
          onPress = handleTabBarEvent
      }        
  end  
  
  selectedTab = 'location'
  
  -- Create the widget
  local tabBar = widget.newTabBar
  {
      top = 20,
      left = 10,
      width = menu_w,
      height = 60,      
      buttons = tabButtons
  }   

  -- Create a image and insert it into the scroll view
  --local background = display.newImageRect( "assets/scrollimage.png", 768, 1024 )
  --scrollView:insert( background )
  
  local stat_bar_h, stat_bar_w = 12, height/9 + offset
  
  function drawStatBar()
    stat_bar = display.newGroup()
    local background_bar = display.newRect(stat_bar_w+offset, stat_bar_h*0.5 + thickness, stat_bar_w, stat_bar_h)
    background_bar.strokeWidth = thickness
    background_bar:setFillColor( 0.5 )
    background_bar:setStrokeColor( 1, 0, 0 )
    stat_bar:insert(background_bar)

    local stat_text
    if main_player:isMobType('human') then      
      local ip, max_ip = main_player:getStat('ip'), main_player:getStat('ip', 'max')
      stat_text = display.newText('IP ['..ip..'/'..max_ip..']', stat_bar_w+offset, stat_bar_h*0.5 + thickness, native.systemFontBold, 10 )
    elseif main_player:isMobType('zombie') then
      local ep, max_ep = main_player:getStat('ep'), main_player:getStat('ep', 'max')
      local decay, max_decay = main_player.condition.decay:getTime(), 1023
      stat_text = display.newText('EP ['..ep..'/'..max_ep..']  DECAY ['..decay..'/'..max_decay..']', stat_bar_w+offset, stat_bar_h*0.5 + thickness, native.systemFontBold, 10 )      
    end
    stat_text:setFillColor( 0, 0, 0 )
    stat_bar:insert(stat_text)    
    sceneGroup:insert(stat_bar)
  end  
  
  actionMenu = getMenu('location', list.location)
  drawStatBar() 
  sceneGroup:insert(tabBar)
  sceneGroup:insert(actionMenu) 
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        --[[
  -- Function to handle button events
  local function handleTabBarEvent( event )
      print( event.target._id )  --reference to button's 'id' parameter
    selectedTab = event.target._id
    actionMenu = redoMenu(event.target._id, list[event.target._id])
    sceneGroup:insert(actionMenu)
  end         
        --]]
print()
print('action scene phase == "will"')
print('selectedTab is - ', selectedTab)
for k,v in pairs(list[selectedTab]) do print(k,v) end
print()
        actionMenu = redoMenu(selectedTab)
        sceneGroup:insert(actionMenu)        
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