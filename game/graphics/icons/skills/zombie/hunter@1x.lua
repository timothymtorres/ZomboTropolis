--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:73b96c901306f900d0175496377aab6a:60fda7a1364362d7d9ad6dbb672180dd:a1b23113e7f37280822ccd80e84fd6ef$
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
            -- double-face-mask
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- eyeball
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- fire-dash
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- hidden
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- nose-side
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- run
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- shadow-follower
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
    ["double-face-mask"] = 2,
    ["eyeball"] = 3,
    ["fire-dash"] = 4,
    ["hidden"] = 5,
    ["nose-side"] = 6,
    ["run"] = 7,
    ["shadow-follower"] = 8,
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
