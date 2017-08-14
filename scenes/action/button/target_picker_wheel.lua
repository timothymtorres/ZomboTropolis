-----------------------------------------------------------------------------------------
--
-- target_picker_wheel.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52 --320, 428
local button_w, button_h = math.floor(width*0.342 + 0.5), math.floor(height*0.093 + 0.5) --110, 40

local function target_picker_wheel()
  local targets = main_player:getTargets()
  local target_names = {}
  
  for i in ipairs(targets) do
    local target_class = targets[i]:getClassName()
    if target_class == 'player' then
      target_names[#target_names+1] = targets[i]:getUsername()
    end
  end
  
  local columnData = {
    {align='center', startIndex=1, labels=target_names},
  }

  return {columns=columnData, columnColor={0.2,0.2,0.2,1}}, targets
end

return target_picker_wheel
