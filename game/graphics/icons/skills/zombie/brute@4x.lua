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
            width=512,
            height=512,

        },
        {
            -- flaming-claw
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- half-body-crawling
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- imprisoned
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- shieldcomb
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- spiked-armor
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- stigmata
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- wolverine-claws
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
