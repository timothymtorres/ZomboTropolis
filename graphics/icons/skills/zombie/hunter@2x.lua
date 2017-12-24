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
            width=256,
            height=256,

        },
        {
            -- double-face-mask
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- eyeball
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- fire-dash
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- hidden
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- nose-side
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- run
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- shadow-follower
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
