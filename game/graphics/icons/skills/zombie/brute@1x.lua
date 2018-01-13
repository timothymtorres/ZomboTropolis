--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:75c0ab175136f18a927eb9b0afaa8ede:2e99795c1774a38d2fe4f239ad1daab4:5f6881ff55620094c7ffc467df14f758$
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
            -- claw-slashes
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- flaming-claw
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- half-body-crawling
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- shieldcomb
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spiked-armor
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- stigmata
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- swallow
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- wolverine-claws
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

    ["claw-slashes"] = 1,
    ["flaming-claw"] = 2,
    ["half-body-crawling"] = 3,
    ["shieldcomb"] = 4,
    ["spiked-armor"] = 5,
    ["stigmata"] = 6,
    ["swallow"] = 7,
    ["wolverine-claws"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
