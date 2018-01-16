--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3a6ff56a11a2faf9284542ad644aa12d:6eb5e9b1eead0117b9c99305cb84fc3c:31a49f9b64123c8184d8f9d9ca4b1789$
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
            -- auto-repair
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- brick-pile
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- closed-doors
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- power-generator
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- processor
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- push
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spanner
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- wooden-door
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

    ["auto-repair"] = 1,
    ["brick-pile"] = 2,
    ["closed-doors"] = 3,
    ["power-generator"] = 4,
    ["processor"] = 5,
    ["push"] = 6,
    ["spanner"] = 7,
    ["wooden-door"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
