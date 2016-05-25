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
            width=512,
            height=512,

        },
        {
            -- fulguro-punch
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- large-slash
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- muscle-fat
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- muscle-up
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- pummeled
            x=0,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- punch
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- quick-slash
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- serrated-slash
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- snatch
            x=512,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- sprint
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- targeting
            x=1024,
            y=1536,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 1536,
    sheetContentHeight = 2048
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
