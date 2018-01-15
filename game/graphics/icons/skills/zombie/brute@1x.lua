--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ed38471a52ee8f02385ff33ce1c29038:09fccc28b1e05aeadf498bfaac0badac:5f6881ff55620094c7ffc467df14f758$
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
            -- amputation
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- claw-slashes
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- decapitation
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- layered-armor
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
            -- slashed-shield
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

    ["amputation"] = 1,
    ["claw-slashes"] = 2,
    ["decapitation"] = 3,
    ["layered-armor"] = 4,
    ["shieldcomb"] = 5,
    ["slashed-shield"] = 6,
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
