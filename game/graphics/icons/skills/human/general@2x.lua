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
            width=256,
            height=256,

        },
        {
            -- coma
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- jump-across
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- large-slash
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
            -- punch
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- quick-slash
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- serrated-slash
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- snatch
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- targeting
            x=1024,
            y=256,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 512
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
