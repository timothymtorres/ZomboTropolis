--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7035b298e0a6e6416b84377043dbeb95:64b4dd25d5ce123ee5a7ee19e0b95dce:848ff5c6cb8f71d964040041056bb1b7$
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
            width=256,
            height=256,

        },
        {
            -- bandage-roll
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- medical-pack-alt
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- sticking-plaster
            x=768,
            y=0,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["anatomy"] = 1,
    ["bandage-roll"] = 2,
    ["medical-pack-alt"] = 3,
    ["sticking-plaster"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
