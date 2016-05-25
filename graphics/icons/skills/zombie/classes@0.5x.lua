--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:8b5cde58d3b6e5b7c76b42f3859cc943:af86392912bd16e0a5dbdc4b8277c330:f566188a86459ae073a2ad0b7302ee8b$
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
            x=0,
            y=0,
            width=64,
            height=64,

        },
        {
            -- lizardman
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- one-eyed
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- tear-tracks
            x=192,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 256,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["frontal-lobe"] = 1,
    ["lizardman"] = 2,
    ["one-eyed"] = 3,
    ["tear-tracks"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
