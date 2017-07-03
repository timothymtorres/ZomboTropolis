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
            width=512,
            height=512,

        },
        {
            -- carnivore-mouth
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- cogsplosion
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- drop
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- fire-breath
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- gluttonous-smile
            x=0,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- grass
            x=512,
            y=512,
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
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- scorpion-tail
            x=512,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- vile-fluid
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- vomiting
            x=1024,
            y=1536,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 1536,
    sheetContentHeight = 2048
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
