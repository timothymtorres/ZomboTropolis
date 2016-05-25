--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:5298dbad9e9f261cf9c1d7ec8a139b20:5bde6d16fda800c4d752b092767a32ad:31a49f9b64123c8184d8f9d9ca4b1789$
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
            -- muscle-fat
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- muscle-up
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- pummeled
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
            -- slap
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
