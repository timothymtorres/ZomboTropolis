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
            width=256,
            height=256,

        },
        {
            -- eyeball
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- fire-dash
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- hidden
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- maggot
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- move
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- nose-side
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- run
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- spill
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- sprint
            x=1024,
            y=256,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 512
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
