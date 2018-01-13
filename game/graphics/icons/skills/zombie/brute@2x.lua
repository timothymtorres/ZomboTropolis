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
            width=256,
            height=256,

        },
        {
            -- flaming-claw
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- half-body-crawling
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- imprisoned
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- shieldcomb
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- spiked-armor
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            -- stigmata
            x=1536,
            y=0,
            width=256,
            height=256,

        },
        {
            -- wolverine-claws
            x=1792,
            y=0,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 256
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
