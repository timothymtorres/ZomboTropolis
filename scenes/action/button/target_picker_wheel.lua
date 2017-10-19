-----------------------------------------------------------------------------------------
--
-- target_picker_wheel.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- 52 is default tabbar height
local width, height = display.contentWidth, display.contentHeight - 52 --320, 428
local button_w, button_h = math.floor(width*0.342 + 0.5), math.floor(height*0.093 + 0.5) --110, 40

local compass = {'North', 'NorthEast', 'East', 'SouthEast', 'South', 'SouthWest', 'West', 'NorthWest'}

local function target_picker_wheel(targets, weapons)  -- change the arg names?  (selection_1, selection_2)
  local target_names, weapon_names = {}, {}

  for i in ipairs(targets) do
    if type(targets[i]) == 'number' then  -- this is used by the gesture action
      target_names[#target_names+1] = compass[targets[i]]
    --elseif type(targets[i]) == 'string' then target_names[#target_names+1] = targets[i]   (used for barricades? doors?)
    else
      local target_class = targets[i]:getClassName()
      
      if target_class == 'player' then target_names[#target_names+1] = targets[i]:getUsername()
      elseif target_class == 'equipment' then target_names[#target_names+1] = targets[i]:getClassName()
      elseif target_class == 'building' then target_names[#target_names+1] = targets[i]:getName()..' '..targets[i]:getClassName()
      end
    end
  end

  local columnData = {}
  columnData[1] = {align='center', startIndex=1, labels=target_names}

  if weapons then
    for i in ipairs(weapons) do 
      local weapon = weapons[i].weapon
      weapon_names[#weapon_names+1] = weapon:getClassName()  -- add condition?  dice_str?
    end        
    columnData[2] = {align='center', width=140, startIndex=1, labels=weapon_names}
  end

  return {columns=columnData, columnColor={0.2,0.2,0.2,1}}  --, targets   (we should omit returning targets if it is already being passed into our params)
end

--[[----------
-- OLD CODE --
--------------

-- This is a ref to how armor was placed into the picker wheel previously. Depending on how organic armor changes later on this may be added again or deleted entirely
-- Another option is to do a seperate picker_wheel for organicArmor since the selections are completely different!

local function getOrganicArmorWheel()
  armor_list = main_player.armor:getAvailableArmors()

  for armor_type, _ in pairs(armor_list) do
    armor_list[#armor_list+1] = armor_type
  end
  
  local columnData = {
    {align='center', startIndex=1, labels=armor_list},
  }
end
--]]

return target_picker_wheel

