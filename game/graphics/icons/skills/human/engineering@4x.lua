--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ad36779889ba8f2b0f50f1c392072f67:6affa68a25f0e28cee65e5ea14100536:31a49f9b64123c8184d8f9d9ca4b1789$
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
            -- closed-doors
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- hammer-nails
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- keyboard
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- light-bulb
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- processor
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- push
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- radar-dish
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- spanner
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- wooden-door
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1536
}

SheetInfo.frameIndex =
{

    ["auto-repair"] = 1,
    ["closed-doors"] = 2,
    ["hammer-nails"] = 3,
    ["keyboard"] = 4,
    ["light-bulb"] = 5,
    ["processor"] = 6,
    ["push"] = 7,
    ["radar-dish"] = 8,
    ["spanner"] = 9,
    ["wooden-door"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
