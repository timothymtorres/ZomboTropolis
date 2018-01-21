--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:122eaa68afb3983b87513acdeac2295a:2407cbb049b76d516cde75cd55c42fdb:a1b23113e7f37280822ccd80e84fd6ef$
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
            -- chewed-heart
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- eyeball
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- fire-dash
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- hidden
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- run
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            -- sprint
            x=1536,
            y=0,
            width=256,
            height=256,

        },
        {
            -- worried-eyes
            x=1792,
            y=0,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["brass-eye"] = 1,
    ["chewed-heart"] = 2,
    ["eyeball"] = 3,
    ["fire-dash"] = 4,
    ["hidden"] = 5,
    ["run"] = 6,
    ["sprint"] = 7,
    ["worried-eyes"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
