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
            width=64,
            height=64,

        },
        {
            -- drop
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fire-breath
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- grass
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- groundbreaker
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- lizard-tongue
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- scorpion-tail
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- vile-fluid
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- vomiting
            x=512,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 576,
    sheetContentHeight = 64
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
