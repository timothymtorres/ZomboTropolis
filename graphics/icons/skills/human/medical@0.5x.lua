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
            width=64,
            height=64,

        },
        {
            -- bandage-roll
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- corked-tube
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fizzing-flask
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- health-increase
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- health-normal
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- medical-pack-alt
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- pill
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- scalpel
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sewing-needle
            x=576,
            y=0,
            width=64,
            height=64,

        },
        {
            -- square-bottle
            x=640,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sticking-plaster
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
