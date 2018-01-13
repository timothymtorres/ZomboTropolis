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
            width=64,
            height=64,

        },
        {
            -- double-face-mask
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- eyeball
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fire-dash
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- hidden
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- nose-side
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- run
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- shadow-follower
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
