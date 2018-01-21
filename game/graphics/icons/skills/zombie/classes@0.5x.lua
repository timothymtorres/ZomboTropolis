--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a7769c2a49851e759a36c10158dbac9d:43c9e24ad190613546bee2d3387afc97:f566188a86459ae073a2ad0b7302ee8b$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- frontal-lobe
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- lizardman
            x=68,
            y=2,
            width=64,
            height=64,

        },
        {
            -- tear-tracks
            x=134,
            y=2,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 200,
    sheetContentHeight = 68
}

SheetInfo.frameIndex =
{

    ["frontal-lobe"] = 1,
    ["lizardman"] = 2,
    ["tear-tracks"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
