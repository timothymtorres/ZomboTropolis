-----------------------------------------------------------------------------------------
--
-- perform_button.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52 --320, 428
local button_w, button_h = math.floor(width*0.342 + 0.5), math.floor(height*0.093 + 0.5) --110, 40

local perform_button = {
  id = 'perform_button',
  label = 'PERFORM',
  shape = 'rect',
  width = button_w,
  height = button_h,
  fillColor = { default={ 1, 0, 0, 1 }, over={ 1, 0.1, 0.7, 0.4 } },
  strokeColor = { default={ 1, 0.4, 0, 1 }, over={ 0.8, 0.8, 1, 1 } },
  strokeWidth = 4,
  --onEvent = performButtonEvent, set in the scene  
}  

return perform_button
