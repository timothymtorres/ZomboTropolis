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
            -- muscle-fat
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- muscle-up
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- pummeled
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- punch
            x=0,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- quick-slash
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- serrated-slash
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- slap
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
