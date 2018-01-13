application = {
	content = {
		width = 320,
		height = 480, 
		scale = "zoomEven",
		fps = 60,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},
  plugins =
  {
      -- key is the name passed to Lua's 'require()'
      ["plugin.bit"] =
      {
          -- required
          publisherId = "com.coronalabs",
      },
  },  

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
