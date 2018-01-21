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
            width=128,
            height=128,

        },
        {
            -- chewed-heart
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
            -- run
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sprint
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- worried-eyes
            x=896,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 128
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
