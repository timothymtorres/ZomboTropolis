--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:56573165e59c64f2e975c634bd4ed5f6:52d41783d469d77c6e9ae6a246979757:a1b23113e7f37280822ccd80e84fd6ef$
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
            -- brass-eye
            x=0,
            y=0,
            width=512,
            height=512,

        },
        {
            -- eyeball
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- fire-dash
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- hidden
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- maggot
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- move
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- nose-side
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- run
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- spill
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- sprint
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

    ["brass-eye"] = 1,
    ["eyeball"] = 2,
    ["fire-dash"] = 3,
    ["hidden"] = 4,
    ["maggot"] = 5,
    ["move"] = 6,
    ["nose-side"] = 7,
    ["run"] = 8,
    ["spill"] = 9,
    ["sprint"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
