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
            width=256,
            height=256,

        },
        {
            -- fulguro-punch
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- large-slash
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- muscle-fat
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- muscle-up
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- pummeled
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- punch
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- quick-slash
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- serrated-slash
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- snatch
            x=1024,
            y=256,
            width=256,
            height=256,

        },
        {
            -- sprint
            x=1280,
            y=0,
            width=256,
            height=256,

        },
        {
            -- targeting
            x=1280,
            y=256,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1536,
    sheetContentHeight = 512
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
