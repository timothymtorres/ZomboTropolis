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
            width=64,
            height=64,

        },
        {
            -- brick-pile
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- closed-doors
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- power-generator
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- processor
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- push
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- spanner
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- wooden-door
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
