--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f956bcfc9d1cfc45001948a4ca5abb00:a54d736276721b08edc9a3004b78b70a:5f6881ff55620094c7ffc467df14f758$
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
            -- imprisoned
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- shieldcomb
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spiked-armor
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- stigmata
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
    ["imprisoned"] = 4,
    ["shieldcomb"] = 5,
    ["spiked-armor"] = 6,
    ["stigmata"] = 7,
    ["wolverine-claws"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
