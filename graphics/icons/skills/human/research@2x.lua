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
            -- muscle-fat
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- muscle-up
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- pummeled
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
            -- slap
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
