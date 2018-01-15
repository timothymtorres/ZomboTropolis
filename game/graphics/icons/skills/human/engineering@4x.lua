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
            width=512,
            height=512,

        },
        {
            -- brick-pile
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- closed-doors
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- power-generator
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- processor
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- push
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- spanner
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- wooden-door
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
