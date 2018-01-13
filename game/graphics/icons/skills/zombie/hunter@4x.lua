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
            width=512,
            height=512,

        },
        {
            -- double-face-mask
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- eyeball
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- fire-dash
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- hidden
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- nose-side
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- run
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- shadow-follower
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
