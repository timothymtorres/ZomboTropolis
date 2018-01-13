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
            width=64,
            height=64,

        },
        {
            -- flaming-claw
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- half-body-crawling
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- imprisoned
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- shieldcomb
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- spiked-armor
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- stigmata
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- wolverine-claws
            x=448,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 64
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
