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
            width=128,
            height=128,

        },
        {
            -- eyeball
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- fire-dash
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- hidden
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- maggot
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- move
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- nose-side
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- run
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spill
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sprint
            x=1152,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 128
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
