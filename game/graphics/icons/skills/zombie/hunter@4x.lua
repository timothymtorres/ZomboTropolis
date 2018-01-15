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
            width=512,
            height=512,

        },
        {
            -- chewed-heart
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- eyeball
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- fire-dash
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- hidden
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- run
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- sprint
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- worried-eyes
            x=1536,
            y=512,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
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
