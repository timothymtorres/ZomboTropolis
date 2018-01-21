--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:18ac18daec2d42733614ca8d625a3b4d:f994d83deae262d3cc6e1d614cb9ac4b:848ff5c6cb8f71d964040041056bb1b7$
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
            -- anatomy
            x=0,
            y=0,
            width=512,
            height=512,

        },
        {
            -- bandage-roll
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- batteries
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- dna1
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- keyboard
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- medical-pack-alt
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- sticking-plaster
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- syringe
            x=1536,
            y=512,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["anatomy"] = 1,
    ["bandage-roll"] = 2,
    ["batteries"] = 3,
    ["dna1"] = 4,
    ["keyboard"] = 5,
    ["medical-pack-alt"] = 6,
    ["sticking-plaster"] = 7,
    ["syringe"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
