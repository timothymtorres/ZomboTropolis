-----------------------------------------------------------------------------------------
--
-- cancel_button.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52 --320, 428
local button_w, button_h = math.floor(width*0.342 + 0.5), math.floor(height*0.093 + 0.5) --110, 40

local cancelButtonEvent = function(event)
  if ('ended' == event.phase) then
    print('Cancel button was pressed and released')
    if active_timer then timer.cancel(active_timer) end    
    composer.hideOverlay('fade', 400)
  end
end

local cancel_button = {
    id = 'cancel_button',
    label = 'CANCEL',
    onEvent = cancelButtonEvent,
    shape = 'rect',
    width = button_w,
    height = button_h,
    fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
    strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
    strokeWidth = 4      
}   

return cancel_button