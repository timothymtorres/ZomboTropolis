--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:64e3c1bd73d82c22c067cdd60c95f5ad:17624fcae1a476aab3c61af09881f5a9:a41a9cfbabe87f4ee87f6dd690025223$
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
            -- bindle
            x=0,
            y=0,
            width=64,
            height=64,

        },
        {
            -- coma
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- jump-across
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- large-slash
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- muscle-up
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- punch
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- quick-slash
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- serrated-slash
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- snatch
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- targeting
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

    ["bindle"] = 1,
    ["coma"] = 2,
    ["jump-across"] = 3,
    ["large-slash"] = 4,
    ["muscle-up"] = 5,
    ["punch"] = 6,
    ["quick-slash"] = 7,
    ["serrated-slash"] = 8,
    ["snatch"] = 9,
    ["targeting"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
