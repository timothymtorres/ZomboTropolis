--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9d8276539b7ef6660d0e1a943acb4cc8:fd941b00d25029106bc2b00dec862e7c:f566188a86459ae073a2ad0b7302ee8b$
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
            -- biohazard
            x=2,
            y=2,
            width=64,
            height=64,

        },
        {
            -- crossed-swords
            x=68,
            y=2,
            width=64,
            height=64,

        },
        {
            -- hospital-cross
            x=134,
            y=2,
            width=64,
            height=64,

        },
        {
            -- tinker
            x=200,
            y=2,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 266,
    sheetContentHeight = 68
}

SheetInfo.frameIndex =
{

    ["biohazard"] = 1,
    ["crossed-swords"] = 2,
    ["hospital-cross"] = 3,
    ["tinker"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
