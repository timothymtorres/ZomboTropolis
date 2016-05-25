--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ee68493515c4569b929f0b31a9c9c6a1:5bde6d16fda800c4d752b092767a32ad:848ff5c6cb8f71d964040041056bb1b7$
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
            -- muscle-fat
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- muscle-up
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pummeled
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- punch
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- quick-slash
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- serrated-slash
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- slap
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
    ["muscle-fat"] = 3,
    ["muscle-up"] = 4,
    ["pummeled"] = 5,
    ["punch"] = 6,
    ["quick-slash"] = 7,
    ["serrated-slash"] = 8,
    ["slap"] = 9,
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
