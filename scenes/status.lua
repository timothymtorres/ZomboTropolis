-----------------------------------------------------------------------------------------
--
-- player.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local width, height = display.contentWidth, display.contentHeight
local populateList

--Items to show in our list
local listItems = main_player.log:read()
  --{date=os.time(), collapsed=true, events={'Honk', 'This is not a drill'} },
  --[[
	{ title = "Location", collapsed = true, row_items_tripled = true, items = {'Attack', 'Speak', 'Search', 'test1', 'test2', 'test3', 'test4'} },
  { date = ???, collapsed = true/false, events = {} },
  --]]
  
  -- The gradient used by the title bar
  local titleGradient = {
    type = 'gradient',
    color1 = { 189/255, 203/255, 220/255, 255/255 }, 
    color2 = { 89/255, 116/255, 152/255, 255/255 },
    direction = "down"
  }  
-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  -- Initialize the scene here.
  -- Example: add display objects to "sceneGroup", add touch listeners, etc. 
 
  -- create a constant for the left spacing of the row content
  local LEFT_PADDING = 10

  --Create a group to hold our widgets & images
  local widgetGroup = display.newGroup()
  --Group to hold our status icons and info
  local StatusGroup = display.newGroup()   
  
  local username, mob_type = main_player:getUsername(), main_player:getMobType()
  local hp, max_hp = main_player:getStat('hp'), main_player:getStat('hp', 'max')
  local ap, max_ap = main_player:getStat('ap'), main_player:getStat('ap', 'max')
  local xp, max_xp = main_player:getStat('xp'), main_player:getStat('xp', 'max')  
  local ip, max_ip
  local ep, max_ep
  
  if main_player:isMobType('human') then ip, max_ip = main_player:getStat('ip'), main_player:getStat('ip', 'max')
  elseif main_player:isMobType('zombie') then ep, max_ep = main_player:getStat('ep'), main_player:getStat('ep', 'max')
  end  
  
  local bars_y_offset = 40
  local bar_num = 1
  local background_stat_text_size = height*0.05
  
  local mob_type_text = display.newText(StatusGroup, 'You are a '..mob_type, width*0.5, 10, native.systemFont, 20)
  mob_type_text.anchorY = 0
  
  local background_AP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_AP_text.anchorX = 0
  background_AP_text:setFillColor( 0.5 )

  local AP_text = display.newText(StatusGroup, "AP", width*0.115, bars_y_offset + height*((0.025*2)*bar_num), native.systemFontBold, 16 )
  AP_text.anchorX = 0
  
  local background_bar_AP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*bar_num), width*0.65, height*0.05, 8 )
  background_bar_AP.anchorX, background_bar_AP.anchorY = 0, 0
  background_bar_AP.strokeWidth = 2
  background_bar_AP:setFillColor( 0.5 )
  background_bar_AP:setStrokeColor(0, 0, 0)
    
  local AP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*bar_num), (width*0.65)*(math.max(ap, 3)/max_ap), height*0.05, 8 )
  AP_bar.anchorX, AP_bar.anchorY = 0, 0
  AP_bar.strokeWidth = 2
  AP_bar:setFillColor( 0, 0, 0.95 )
  AP_bar:setStrokeColor( 0, 0, 0 )
  
  local AP_stat = display.newText(StatusGroup, '('..ap..'/'..max_ap..')', width*0.65, bars_y_offset + height*((0.025*2)*bar_num), native.systemFontBold, 12 )
  AP_text.anchorX = 0  
  
  bar_num = bar_num + 1
  
  local background_HP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.5)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_HP_text.anchorX = 0
  background_HP_text:setFillColor( 0.5 )

  local HP_text = display.newText(StatusGroup, "HP", width*0.115, bars_y_offset + height*((0.025*2.5)*bar_num), native.systemFontBold, 16 )
  HP_text.anchorX = 0
  
  local background_bar_HP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2)*bar_num, width*0.65, height*0.05, 8 )
  background_bar_HP.anchorX, background_bar_HP.anchorY = 0, 0
  background_bar_HP.strokeWidth = 2
  background_bar_HP:setFillColor( 0.5 )
  background_bar_HP:setStrokeColor(0, 0, 0)
    
  local HP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2)*bar_num, (width*0.65)*(math.max(hp,3)/max_hp), height*0.05, 8 )
  HP_bar.anchorX, HP_bar.anchorY = 0, 0
  HP_bar.strokeWidth = 2
  HP_bar:setFillColor( 0.80, 0, 0 )
  HP_bar:setStrokeColor( 0, 0, 0 )
  
  local HP_stat = display.newText(StatusGroup, '('..hp..'/'..max_hp..')', width*0.65, bars_y_offset + height*((0.025*2.5)*bar_num), native.systemFontBold, 12 )
  HP_text.anchorX = 0  
  
  bar_num = bar_num + 1 
  
  local background_XP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.7)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
  background_XP_text.anchorX = 0
  background_XP_text:setFillColor( 0.5 )

  local XP_text = display.newText(StatusGroup, "XP", width*0.115, bars_y_offset + height*((0.025*2.7)*bar_num), native.systemFontBold, 16 )
  XP_text.anchorX = 0
  
  local background_bar_XP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.3)*bar_num, width*0.65, height*0.05, 8 )
  background_bar_XP.anchorX, background_bar_XP.anchorY = 0, 0
  background_bar_XP.strokeWidth = 2
  background_bar_XP:setFillColor( 0.5 )
  background_bar_XP:setStrokeColor(0, 0, 0)
    
  local XP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.3)*bar_num, (width*0.65)*(math.max(xp,50)/max_xp), height*0.05, 8 )
  XP_bar.anchorX, XP_bar.anchorY = 0, 0
  XP_bar.strokeWidth = 2
  XP_bar:setFillColor( 0.5, 0, 0.5 )
  XP_bar:setStrokeColor( 0, 0, 0 )
  
  local XP_stat = display.newText(StatusGroup, '('..xp..'/'..max_xp..')', width*0.65, bars_y_offset + height*((0.025*2.7)*bar_num), native.systemFontBold, 12 )
  XP_text.anchorX = 0  
  
  bar_num = bar_num + 1  
  
  if main_player:isMobType('human') then 
    local background_IP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.8)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
    background_IP_text.anchorX = 0
    background_IP_text:setFillColor( 0.5 )

    local IP_text = display.newText(StatusGroup, "IP", width*0.115, bars_y_offset + height*((0.025*2.8)*bar_num), native.systemFontBold, 16 )
    IP_text.anchorX = 0
    
    local background_bar_IP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, width*0.65, height*0.05, 8 )
    background_bar_IP.anchorX, background_bar_IP.anchorY = 0, 0
    background_bar_IP.strokeWidth = 2
    background_bar_IP:setFillColor( 0.5 )
    background_bar_IP:setStrokeColor(0, 0, 0)
      
    local IP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, (width*0.65)*(math.max(ip,50)/max_ip), height*0.05, 8 )
    IP_bar.anchorX, IP_bar.anchorY = 0, 0
    IP_bar.strokeWidth = 2
    IP_bar:setFillColor( 0.7, 0.7, 0.2  )
    IP_bar:setStrokeColor( 0, 0, 0 )
    
    local IP_stat = display.newText(StatusGroup, '('..ip..'/'..max_ip..')', width*0.65, bars_y_offset + height*((0.025*2.75)*bar_num), native.systemFontBold, 12 )
    IP_text.anchorX = 0  
    
    bar_num = bar_num + 1  
    
  elseif main_player:isMobType('zombie') then 
    local background_EP_text = display.newRect( StatusGroup, width*0.05, bars_y_offset + height*((0.025*2.8)*bar_num),  background_stat_text_size*2.5, background_stat_text_size*1.25)
    background_EP_text.anchorX = 0
    background_EP_text:setFillColor( 0.5 )

    local EP_text = display.newText(StatusGroup, "EP", width*0.115, bars_y_offset + height*((0.025*2.8)*bar_num), native.systemFontBold, 16 )
    EP_text.anchorX = 0
    
    local background_bar_EP = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, width*0.65, height*0.05, 8 )
    background_bar_EP.anchorX, background_bar_EP.anchorY = 0, 0
    background_bar_EP.strokeWidth = 2
    background_bar_EP:setFillColor( 0.5 )
    background_bar_EP:setStrokeColor(0, 0, 0)
      
    local EP_bar = display.newRoundedRect( StatusGroup, width*0.30, bars_y_offset + height*(0.025*2.5)*bar_num, (width*0.65)*(math.max(ep,50)/max_ep), height*0.05, 8 )
    EP_bar.anchorX, EP_bar.anchorY = 0, 0
    EP_bar.strokeWidth = 2
    EP_bar:setFillColor( 0.7, 0.7, 0.2 )
    EP_bar:setStrokeColor( 0, 0, 0 )
    
    local EP_stat = display.newText(StatusGroup, '('..ep..'/'..max_ep..')', width*0.65, bars_y_offset + height*((0.025*2.75)*bar_num), native.systemFontBold, 12 )
    EP_text.anchorX = 0  
    
    bar_num = bar_num + 1   
  end
  
--[[
  -- Create toolbar to go at the top of the screen
  local titleBar = display.newRect( display.contentCenterX, 0, display.contentWidth, 32 )
  titleBar:setFillColor( titleGradient )
  titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

  -- create embossed text to go on toolbar
  local titleText = display.newEmbossedText( "Events", display.contentCenterX, titleBar.y, native.systemFontBold, 20 )

  -- Forward reference for our back button & tableview
  local backButton, list
  local rowTitles = {}

local function onCategoryTap(event)
    local row = event.target
    print("tapped Category", row.id)
    
    for k,v in pairs(rowTitles) do rowTitles[k]=nil end
    
    listItems[row.id].collapsed = not listItems[row.id].collapsed
    list:deleteAllRows()
    populateList()
end

-- Handle row rendering
local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	local isCategory = row.isCategory  
	-- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
	-- in order to use contentHeight properly, we cache the variable before inserting objects into the group

	local groupContentHeight = row.contentHeight

    local rowTitle = display.newText( row, rowTitles[row.index][1], 0, 0, 300, 0, native.systemFontBold, 16 )
    -- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
    rowTitle.x = LEFT_PADDING + 15    -- we also set the anchorX of the text to 0, so the object is x-anchored at the left
    rowTitle.anchorX = 0

    rowTitle.y = groupContentHeight * 0.5
    rowTitle:setFillColor( 0, 0, 0 )    
        --print("ORR called")
	
	if isCategory then          
            local categoryBtn = display.newRect( row, 0, 0, row.width, row.height )
            categoryBtn.anchorX, categoryBtn.anchorY = 0, 0
            categoryBtn:addEventListener ( "tap", onCategoryTap )
            categoryBtn.alpha = 0
            categoryBtn.isHitTestable = true
            categoryBtn.id = row.id
            local icon = display.newRect(row, 0, 0, 5, 5)
            icon.x = LEFT_PADDING
            icon.anchorX = 0
            icon.y = groupContentHeight * 0.5
	end
end

  -- Hande row touch events
  local function onRowTouch( event )
    local phase = event.phase
    local row = event.target
    
    if "press" == phase then
      print( "Pressed row: " .. row.index )

    elseif "release" == phase then
      -- Update the item selected text
      itemSelected.text = "You selected: " .. rowTitles[row.index]
      
      print( "Tapped and/or Released row: " .. row.index )
    end
  end

  -- Create a tableView
  list = widget.newTableView
  {
    top = 32,
    width = 320, 
    height = 350,
    maskFile = "mask-320x448.png",
    onRowRender = onRowRender,
    onRowTouch = onRowTouch,
  }

  --Insert widgets/images into a group
  widgetGroup:insert( list )
  widgetGroup:insert( titleBar )
  widgetGroup:insert( titleText )

  function populateList() 
    for i = 1, #listItems do
      --Add the rows category title
      rowTitles[ #rowTitles + 1 ] = {os.date('%x', listItems[i].date)}
      
      --Insert the category
      list:insertRow{
        id = i,
        rowHeight = 30,
        rowColor = 
        { 
          default = { 150/255, 160/255, 180/255, 200/255 },
        },
        isCategory = true,
      }

      if not listItems[i].collapsed then            
        --Insert the item
        for j = 1, #listItems[i].events do
          --Add the event messages
          rowTitles[ #rowTitles + 1 ] = {listItems[i].events[j]}

          --Insert the item
          list:insertRow{
            rowHeight = 60,
            isCategory = false,
            listener = onRowTouch,
          }
        end   
      end
    end 
  end


  populateList()  
  --]]
  sceneGroup:insert(widgetGroup)
  sceneGroup:insert(StatusGroup)
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      listItems = main_player.log:read()
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
      composer.removeScene( "scenes.status" )  
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