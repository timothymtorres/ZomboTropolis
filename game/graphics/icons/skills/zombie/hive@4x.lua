--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a2af8207de1c2f25e3af245f08aa045f:49f90a8f4e9e0b3409d0b6ad5ef34fd6:2492d56173e5d52650a93ad822cbdf6a$
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
            -- carnivore-mouth
            x=0,
            y=0,
            width=512,
            height=512,

        },
        {
            -- cogsplosion
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- drop
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- fire-breath
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- gluttonous-smile
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- groundbreaker
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- lizard-tongue
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- vile-fluid
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

    ["carnivore-mouth"] = 1,
    ["cogsplosion"] = 2,
    ["drop"] = 3,
    ["fire-breath"] = 4,
    ["gluttonous-smile"] = 5,
    ["groundbreaker"] = 6,
    ["lizard-tongue"] = 7,
    ["vile-fluid"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
