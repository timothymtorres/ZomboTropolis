--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f54fe55f3dee6a4ee41b626b02c879f6:2a79796cbe3166f766d6508f733f62b7:a41a9cfbabe87f4ee87f6dd690025223$
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
            width=128,
            height=128,

        },
        {
            -- coma
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- jump-across
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- large-slash
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- punch
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- quick-slash
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- serrated-slash
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- snatch
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sprint
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- targeting
            x=1152,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["bindle"] = 1,
    ["coma"] = 2,
    ["jump-across"] = 3,
    ["large-slash"] = 4,
    ["punch"] = 5,
    ["quick-slash"] = 6,
    ["serrated-slash"] = 7,
    ["snatch"] = 8,
    ["sprint"] = 9,
    ["targeting"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
