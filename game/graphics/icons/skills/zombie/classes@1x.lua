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
            width=128,
            height=128,

        },
        {
            -- lizardman
            x=132,
            y=2,
            width=128,
            height=128,

        },
        {
            -- tear-tracks
            x=262,
            y=2,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 392,
    sheetContentHeight = 132
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
