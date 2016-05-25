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
            width=128,
            height=128,

        },
        {
            -- bandage-roll
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- corked-tube
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- fizzing-flask
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- health-increase
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- health-normal
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- medical-pack-alt
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pill
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- scalpel
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sewing-needle
            x=1152,
            y=0,
            width=128,
            height=128,

        },
        {
            -- square-bottle
            x=1280,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sticking-plaster
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
