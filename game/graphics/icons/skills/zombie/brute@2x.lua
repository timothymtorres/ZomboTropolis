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
            width=256,
            height=256,

        },
        {
            -- claw-slashes
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- decapitation
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- layered-armor
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
            -- slashed-shield
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            -- swallow
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
