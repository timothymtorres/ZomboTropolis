--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:315d25efd358e0c45240ebefe1ff9226:4e9f05e9c3a73bdc6be58643d5c0e6bc:a41a9cfbabe87f4ee87f6dd690025223$
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
            -- aerosol
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- fulguro-punch
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- large-slash
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- muscle-fat
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- muscle-up
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pummeled
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- punch
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- quick-slash
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- serrated-slash
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- snatch
            x=1152,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sprint
            x=1280,
            y=0,
            width=128,
            height=128,

        },
        {
            -- targeting
            x=1408,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1536,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["aerosol"] = 1,
    ["fulguro-punch"] = 2,
    ["large-slash"] = 3,
    ["muscle-fat"] = 4,
    ["muscle-up"] = 5,
    ["pummeled"] = 6,
    ["punch"] = 7,
    ["quick-slash"] = 8,
    ["serrated-slash"] = 9,
    ["snatch"] = 10,
    ["sprint"] = 11,
    ["targeting"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
