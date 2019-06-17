local lfs  = require 'lfs'  -- lfs stands for LuaFileSystem

local function buildSequences(tileset)
	local sequences = sequences or {}
	local tiles = tileset.tiles or {}

	for _, tile in ipairs(tiles) do
		local animation  = tile.animation

		if animation then 
			local frames = {}
			local duration = 0

			-- The property tileid starts from 0 (in JSON format)
			-- but frames count from 1
			for _, frame in ipairs(animation) do
				frames[#frames + 1] = frame.tileid + 1 -- maybe make this + 0 instead?
				duration = duration + frame.duration
			end

			local name          = tile.properties.name
			local time          = tile.properties.time or duration
			local loopCount     = tile.properties.loopCount
			local loopDirection = tile.properties.loopDirection

			sequences[#sequences + 1] = {
				frames        = frames,
	            name          = name,
	            time          = time,
	            loopCount     = loopCount,
	            loopDirection = loopDirection
	        }

	        assert(name, 'Character mob tileset is missing name for animation')
	        assert(not sequences[name], 'Character mob tilesets has duplicate animation names')
	        sequences[name] = sequences[#sequences]
	    end 
	end
	return sequences
end

local function loadDefaultTileset(directory)
	-- file must be default_tileset.lua in the starting directory
	-- yes I know that it's technically hardcoded, but meh cutting corners here
  local require_path = directory .. '.' .. "default_tileset"
  -- Replace slashes with periods in require path else file won't load
	lua_path = require_path:gsub("[/\]", ".")

  local options

	local is_code_safe, tileset = pcall(require, lua_path)

	if is_code_safe then
		options = {
			frames             = {},
			sheetContentWidth  = tileset.image_width,
			sheetContentHeight = tileset.image_height,
		}

		local frames            = options.frames
		local tileset_height    = tileset.tilecount / tileset.columns 
		local tileset_width     = tileset.columns 

		for j=1, tileset_height do
		  for i=1, tileset_width do
		    local element = {
				x      = (i - 1)*(tileset.tilewidth + tileset.spacing) + tileset.margin,
				y      = (j - 1)*(tileset.tileheight + tileset.spacing) + tileset.margin,
				width  = tileset.tilewidth,
				height = tileset.tileheight,
		    }
		    frames[#frames + 1] = element
		  end
		end
	end

	return tileset, options
end

local tilesets = {}
local default_tileset, default_options

local function loadMobTilesets(directory)
  local path = system.pathForFile(directory, system.ResourceDirectory) 

  if not default_tileset then 
  	default_tileset, default_options = loadDefaultTileset(directory) 
  end
  -- need to do body.lua first and save to sequences

	for file in lfs.dir(path) do
		-- This pattern captures the name and extension of a file string
		local file_name, extension = file:match("(.*)%.(.+)$")
		local is_image_file = file ~= '.' and file ~= '..' and extension == 'png'
		local attr = lfs.attributes(path..'/'..file)
		local is_directory = file ~= '.' and file ~= '..' and attr.mode == 'directory'

    if is_directory then  -- search sub-directories
			loadMobTilesets(directory .. '/' .. file)
		elseif is_image_file then
			local image = file_name

			tilesets[image] = buildSequences(default_tileset)
			tilesets[image].sheet = graphics.newImageSheet(directory .. '/' .. file, 
                                                     default_options)

--[[
			test = display.newSprite(tilesets[image].sheet, tilesets[image])
			test.x, test.y = math.random(100, 300), math.random(50, 250)
			test:setSequence('walk-east')
			test:play()
--]]
		end
	end

	return tilesets
end

return loadMobTilesets