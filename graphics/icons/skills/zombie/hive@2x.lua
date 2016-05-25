--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:d0af23fedc0689ee8444e12558e5c2b2:bd52d28245c844126cdacf4b8d0c49d4:2492d56173e5d52650a93ad822cbdf6a$
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
            -- cogsplosion
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            -- drop
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- fire-breath
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- grass
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- groundbreaker
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- lizard-tongue
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- scorpion-tail
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- vile-fluid
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- vomiting
            x=1024,
            y=0,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["cogsplosion"] = 1,
    ["drop"] = 2,
    ["fire-breath"] = 3,
    ["grass"] = 4,
    ["groundbreaker"] = 5,
    ["lizard-tongue"] = 6,
    ["scorpion-tail"] = 7,
    ["vile-fluid"] = 8,
    ["vomiting"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
