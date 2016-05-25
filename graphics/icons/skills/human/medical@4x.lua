--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:db0a0dc66826bac8d2513cb33eeef4eb:2884c3a7a954140e63305d99edf4846d:4b03065a340ef2380c512c189c2e0878$
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
            -- anatomy
            x=0,
            y=0,
            width=512,
            height=512,

        },
        {
            -- bandage-roll
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- corked-tube
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- fizzing-flask
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- health-increase
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- health-normal
            x=0,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- medical-pack-alt
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- pill
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- scalpel
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- sewing-needle
            x=512,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- square-bottle
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- sticking-plaster
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

    ["anatomy"] = 1,
    ["bandage-roll"] = 2,
    ["corked-tube"] = 3,
    ["fizzing-flask"] = 4,
    ["health-increase"] = 5,
    ["health-normal"] = 6,
    ["medical-pack-alt"] = 7,
    ["pill"] = 8,
    ["scalpel"] = 9,
    ["sewing-needle"] = 10,
    ["square-bottle"] = 11,
    ["sticking-plaster"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
