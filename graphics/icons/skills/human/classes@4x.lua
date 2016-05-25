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
            width=512,
            height=512,

        },
        {
            -- crossed-swords
            x=2,
            y=516,
            width=512,
            height=512,

        },
        {
            -- hospital-cross
            x=516,
            y=2,
            width=512,
            height=512,

        },
        {
            -- tinker
            x=516,
            y=516,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 1030,
    sheetContentHeight = 1030
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
