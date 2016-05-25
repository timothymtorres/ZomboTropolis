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
            width=64,
            height=64,

        },
        {
            -- eyeball
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fire-dash
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- hidden
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- maggot
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- move
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- nose-side
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- run
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- spill
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sprint
            x=576,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 640,
    sheetContentHeight = 64
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
