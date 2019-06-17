local lfs  = require 'lfs'  -- lfs stands for LuaFileSystem

local function loadClothing(directory)
  local clothing = {}
  local path = system.pathForFile(directory, system.ResourceDirectory) 

	for folder in lfs.dir(path) do
		local attr = lfs.attributes(path..'/'..folder)
		local is_directory = folder ~= '.' and folder ~= '..' and attr.mode == 'directory'

  	if is_directory then
      clothing[folder] = {}

      local folder_path = system.pathForFile(directory..'/'..folder, system.ResourceDirectory)
      for image in lfs.dir(folder_path) do
        local image_name, extension = image:match("(.*)%.(.+)$")
        local is_image_file = image ~= '.' and image ~= '..' and extension == 'png'
        if is_image_file then table.insert(clothing[folder], image_name) end
      end
		end
  end

	return clothing
end

return loadClothing