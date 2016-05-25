--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3e047a4f9215a19719e96e7125ab9ed9:4e9f05e9c3a73bdc6be58643d5c0e6bc:a41a9cfbabe87f4ee87f6dd690025223$
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
            width=64,
            height=64,

        },
        {
            -- fulguro-punch
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- large-slash
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- muscle-fat
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
            -- pummeled
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- punch
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- quick-slash
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- serrated-slash
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- snatch
            x=576,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sprint
            x=640,
            y=0,
            width=64,
            height=64,

        },
        {
            -- targeting
            x=704,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 768,
    sheetContentHeight = 64
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
