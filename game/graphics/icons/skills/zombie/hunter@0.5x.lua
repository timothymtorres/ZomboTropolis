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
            width=64,
            height=64,

        },
        {
            -- chewed-heart
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
            -- run
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sprint
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- worried-eyes
            x=448,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 64
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
