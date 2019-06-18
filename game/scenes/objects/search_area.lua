local lume = require('code.libs.lume')
local createMob = require('scenes.functions.createMob')
local moveMobsToSpawns = require('scenes.functions.moveMobsToSpawns')

local SEARCH_DELAY = 1500
local TOUCH_DELAY = 1000

local function Plugin(search_area)   
  search_area.alpha = 0.01 -- the minimal alpha for tap/touch events to register
  search_area.isVisible = true

  local function search()
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if not mob.player:canPerform('search') then
      -- make error sound
      mob:cancelTimers()
      mob:cancelAction() 
      mob:moveToLastPosition() 
      return       
    end

    local result = main_player:perform('search')
    local discovery = result[3]
    local flashlight_state = result[4]
    -- do flashlight scene effects later?  Use shader layer in Tiled, combine
    -- with dynamically generated circle and arc-lines with gradients applied
    -- on top of a mask, will prolly be a PIA

    local item, hidden_player, junk
    if discovery and discovery:isInstanceOf('Item') then item = discovery
    elseif discovery and discovery:isInstanceOf('Player') then hidden_player = discovery
    elseif not discovery then junk = true
    end

    if item or junk then
      local name = item and string.lower(tostring(item)) or 'junk'
print('WE FOUND '..name)    
      local sprite = search_area.map:addSprite("Item", name, mob.x, mob.y - 22)

      local SHRINK_SCALE = 0.30
      local shrink_options = {
        time=SEARCH_DELAY,
        transition=easing.inOutExpo,
        x=mob.x,
        y=mob.y,
        xScale=SHRINK_SCALE,
        yScale=SHRINK_SCALE,
        onComplete=function() 
          sprite:removeSelf()
          if not mob:isTouch('searching') then mob:moveToLastPosition() end
        end,
      }

      if junk then -- toss aside overhead
        shrink_options.x = mob.x + 45
        shrink_options.y = mob.y - 35
        shrink_options.rotation = mob.rotation + 160 
      end

      transition.to(sprite, shrink_options)
    elseif hidden_player then
      -- make zombie sound

      local hidden_mob = createMob(hidden_player, search_area.map)
      hidden_mob.x, hidden_mob.y =  search_area.x - 50, search_area.y
      hidden_mob.alpha = 0.3
      hidden_mob:stopPhysics()

      mob:cancelTimers()
      mob:cancelAction()
      mob:stopPhysics()

      local reveal_options = {
        time = SEARCH_DELAY,
        threshold = 1,
        alpha = 1,
        transition=easing.inOutExpo,
        onComplete=function()
          moveMobsToSpawns(search_area.map, main_player:getLocation(), main_player:getStage() )
        end,
      }

      transition.to(hidden_mob, reveal_options)
    end
  end

  function search_area.touch(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    -- if player cannot search then ignore touch events
    if not mob.player:canPerform('search') and event.phase == "began" then
      display.getCurrentStage():setFocus(nil)
      return false
    end

    if event.phase == "began" and mob:isTouch(nil) and mob.isBodyActive then
      display.getCurrentStage():setFocus(event.target)
      local touch_options = {
        delay=TOUCH_DELAY,
        onComplete=function()
          mob.action_timer = timer.performWithDelay(SEARCH_DELAY, search, 0)
          search()
        end,
      }
      mob:setTouch('searching')
      mob:moveTo(search_area, touch_options)
    elseif (event.phase == "ended" or event.phase == "cancelled") then
      display.getCurrentStage():setFocus(nil) 
    end

    local TOUCH_CANCEL_DISTANCE = 5
    local distance = lume.distance(event.x, event.y, event.xStart, event.yStart)

    -- touch move/end/cancel phases result in search being canceled
    if mob:isTouch('searching') and ((event.phase == "moved" and 
    distance > TOUCH_CANCEL_DISTANCE) or event.phase == "ended" or 
    event.phase == "cancelled") then
      mob:cancelTimers()
      mob:cancelAction()
    end

    return true
  end

  function search_area.tap(event)
    local mob = search_area.map:getObjects({name=tostring(main_player)})

    if not mob.player:canPerform('search') then
      -- make error sound
      return     
    end

    if ( event.numTaps == 2 ) and mob.isBodyActive then
      local tap_options = {onComplete=search,}
      mob:moveTo(search_area, tap_options)
    end
  end

  -- only let a standing human click on search areas that they are in
  if main_player:isStaged(search_area.name) and main_player:isMobType('human') 
  and main_player:isStanding() then
    search_area:addEventListener("tap", search_area.tap) 
    search_area:addEventListener("touch", search_area.touch)
  end

  return search_area
end

return Plugin