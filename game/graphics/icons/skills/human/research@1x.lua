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
            width=128,
            height=128,

        },
        {
            -- bandage-roll
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- batteries
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- dna1
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- keyboard
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- medical-pack-alt
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sticking-plaster
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- syringe
            x=896,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 128
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
