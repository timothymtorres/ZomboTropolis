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
local inv_list = {'pistol [0/6]', 'shotgun [0/2]', 'katanna', 'baseball bat', 'generator'}
local width, height = display.contentWidth, display.contentHeight

local populateList

--Items to show in our list
local listItems = {
	{ title = "Location", collapsed = true, row_items_tripled = true, items = {'Attack', 'Speak', 'Search', 'test1', 'test2', 'test3', 'test4'} },
--{ title = "Building", collapsed = true, items = { "Sandwich", "Taco", "Noodles", "Soup", "Fries" } },
	{ title = "Skills", collapsed = true, items = { "Pizza", "Burger", "Steak", "Beef", "Lamb" } },
	{ title = "Items", collapsed = true, items = inv_list},
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

-- The gradient used by the title bar
local titleGradient = {
	type = 'gradient',
	color1 = { 189/255, 203/255, 220/255, 255/255 }, 
	color2 = { 89/255, 116/255, 152/255, 255/255 },
	direction = "down"
}

-- Create toolbar to go at the top of the screen
local titleBar = display.newRect( display.contentCenterX, 0, display.contentWidth, 32 )
titleBar:setFillColor( titleGradient )
titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "Action List", display.contentCenterX, titleBar.y, native.systemFontBold, 20 )

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
  local itemTripled = row.params.itemTripled
	
for k,v in pairs(event.row) do print(k,v) end
  
	-- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
	-- in order to use contentHeight properly, we cache the variable before inserting objects into the group

	local groupContentHeight = row.contentHeight

print('row.itemTripled = ', row.itemTripled)
  if itemTripled then
    
print(rowTitles[row.index][1]..' is Tripled.')
print(rowTitles[row.index][1], rowTitles[row.index][2], rowTitles[row.index][3])   
    local rowTitleLeft = display.newText( row, rowTitles[row.index][1], 0, 0, native.systemFontBold, 16 )
    -- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
    rowTitleLeft.x = LEFT_PADDING + 15
    -- we also set the anchorX of the text to 0, so the object is x-anchored at the left
    rowTitleLeft.anchorX = 0
    rowTitleLeft.y = groupContentHeight * 0.5
    rowTitleLeft:setFillColor( 0, 0, 0 )    
    
    if rowTitles[row.index][2] then
      local rowTitleCenter = display.newText( row, rowTitles[row.index][2], 0, 0, native.systemFontBold, 16 )
      -- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
      --rowTitleCenter.x = LEFT_PADDING + 15
      rowTitleCenter.anchorX = 100
      rowTitleCenter.y = groupContentHeight * 0.5
      rowTitleCenter:setFillColor( 0, 0, 0 )    
    end
    
    if rowTitles[row.index][3] then
      local rowTitleRight = display.newText( row, rowTitles[row.index][3], 0, 0, native.systemFontBold, 16 )
      --rowTitleRight.x = LEFT_PADDING + 15
      rowTitleRight.anchorX = width
      rowTitleRight.y = groupContentHeight * 0.5
      rowTitleRight:setFillColor( 0, 0, 0 )
    end
  else
print(rowTitles[row.index][1]..' is NOT Tripled.')     
for k,v in pairs(rowTitles[row.index]) do print(k,v) end
    local rowTitle = display.newText( row, rowTitles[row.index][1], 0, 0, native.systemFontBold, 16 )
    -- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
    rowTitle.x = LEFT_PADDING + 15    -- we also set the anchorX of the text to 0, so the object is x-anchored at the left
    rowTitle.anchorX = 0

    rowTitle.y = groupContentHeight * 0.5
    rowTitle:setFillColor( 0, 0, 0 )    
  end
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
        --[[    
            local catIndicator = nil 
            if listItems[row.id].collapsed then
                catIndicator = display.newImage( row, "rowArrow.png", false )
            else
                catIndicator = display.newImage( row, "rowArrowDown.png", false )
            end
            catIndicator.x = LEFT_PADDING
            catIndicator.anchorX = 0
            catIndicator.y = groupContentHeight * 0.5
            
        else
		local rowArrow = display.newImage( row, "rowArrow.png", false )
                
                rowArrow.x = row.contentWidth - LEFT_PADDING

		-- we set the image anchorX to 1, so the object is x-anchored at the right
		rowArrow.anchorX = 1

		-- we set the image anchorX to 1, so the object is x-anchored at the right
		rowArrow.y = groupContentHeight * 0.5
        --]]
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
	rowTitles[ #rowTitles + 1 ] = {listItems[i].title}
	
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
        print(listItems[i].collapsed )
        if not listItems[i].collapsed then
            if listItems[i].row_items_tripled then
print()
print('row items tripled true for listItems[i]')
print()
              for j = 1, #listItems[i].items, 3 do
                      rowTitles[#rowTitles + 1] = {listItems[i].items[j], listItems[i].items[j+1], listItems[i].items[j+2]}
                      --Insert the item
                      list:insertRow{
                              rowHeight = 60,
                              isCategory = false,
                              listener = onRowTouch,
                              params = {itemTripled = true},
                      }
              end
            else              
              --Insert the item
              for j = 1, #listItems[i].items do
                      --Add the rows item title
                      rowTitles[ #rowTitles + 1 ] = {listItems[i].items[j]}

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
    
end

  populateList()  
  sceneGroup:insert(widgetGroup)
 
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