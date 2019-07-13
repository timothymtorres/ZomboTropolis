local lume = require('code.libs.lume')
local lfs  = require 'lfs'  -- lfs stands for LuaFileSystem

local directory = 'graphics/mob'  -- this is hardcoded for now
local clothing = {}
clothing.draw_order = {"skin", "legs", "feet", "body", "hair", "head"}

--[[--
clothing.skin.zombie = {green1, green2}
clothing.skin.human = {dark1, dark2, tanned1, etc.}
clothing.skin.corpse = {pale1, pale2}

clothing.legs = {pant_green, pant_white, etc.}
clothing.feet = {shoe1, shoe2}
clothing.body = {shirt1, shirt2}
clothing.hair = {afro, ponytail, bedhead}
clothing.head = {cloth, helmet, bandanna}
--]]--

do
  local path = system.pathForFile(directory, system.ResourceDirectory) 

	for category in lfs.dir(path) do
		local attr = lfs.attributes(path..'/'..category)
		local is_directory = category ~= '.' and category ~= '..' and attr.mode == 'directory'

  	if is_directory then
      clothing[category] = {}

      if category == 'skin' then 
        local skin_path = system.pathForFile(directory..'/'..category, system.ResourceDirectory)         
        for mob_type in lfs.dir(skin_path) do
          local attr = lfs.attributes(skin_path..'/'..mob_type)
          local is_mob_directory = mob_type ~= '.' and mob_type ~= '..' and attr.mode == 'directory'

          if is_mob_directory then
            clothing[category][mob_type] = {}

            local mob_path = system.pathForFile(directory..'/'..category..'/'..mob_type, system.ResourceDirectory)
            for image in lfs.dir(mob_path) do
              local image_name, extension = image:match("(.*)%.(.+)$")
              local is_image_file = image ~= '.' and image ~= '..' and extension == 'png'
              if is_image_file then table.insert(clothing[category][mob_type], image_name) end
            end
          end
        end
      else -- just clothing
        -- option to have no clothing for category
        table.insert(clothing[category], 'none')

        local category_path = system.pathForFile(directory..'/'..category, system.ResourceDirectory)
        for image in lfs.dir(category_path) do
          local image_name, extension = image:match("(.*)%.(.+)$")
          local is_image_file = image ~= '.' and image ~= '..' and extension == 'png'
          if is_image_file then table.insert(clothing[category], image_name) end
        end
      end
		end
  end
end

function clothing:generateRandom(mob_type)
  local cosmetics = {}

  for _, category in ipairs(self.draw_order) do
    local selection
    if category == 'skin' then selection = lume.randomchoice(self[category][mob_type])
    else                       selection = lume.randomchoice(self[category])
    end

    cosmetics[category] = selection ~= 'none' and selection or nil
  end

  return cosmetics
end

return clothing