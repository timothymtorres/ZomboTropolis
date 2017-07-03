--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:12cdc1d69ddc2e9feb09490b0d7a4bc8:2fefb655485e16a7fac75764652ac7c6:2492d56173e5d52650a93ad822cbdf6a$
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
            -- brain-stem
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            -- carnivore-mouth
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- cogsplosion
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- drop
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- fire-breath
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- gluttonous-smile
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- grass
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- groundbreaker
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- lizard-tongue
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- scorpion-tail
            x=1024,
            y=256,
            width=256,
            height=256,

        },
        {
            -- vile-fluid
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            -- vomiting
            x=1280,
            y=256,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1536,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["brain-stem"] = 1,
    ["carnivore-mouth"] = 2,
    ["cogsplosion"] = 3,
    ["drop"] = 4,
    ["fire-breath"] = 5,
    ["gluttonous-smile"] = 6,
    ["grass"] = 7,
    ["groundbreaker"] = 8,
    ["lizard-tongue"] = 9,
    ["scorpion-tail"] = 10,
    ["vile-fluid"] = 11,
    ["vomiting"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
