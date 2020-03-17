--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:9625012644d5b70cfda912e2fd9ea35f:c82155c58b7140307cc6cbb6555500b2:1a07471fad41e84a5a5d6e89f55f3227$
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
            -- antidote
            x=0,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bandage
            x=32,
            y=0,
            width=32,
            height=32,

        },
        {
            -- barricade
            x=64,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bat
            x=96,
            y=0,
            width=32,
            height=32,

        },
        {
            -- biosuit
            x=128,
            y=0,
            width=32,
            height=32,

        },
        {
            -- book
            x=160,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bottle
            x=192,
            y=0,
            width=32,
            height=32,

        },
        {
            -- clip
            x=224,
            y=0,
            width=32,
            height=32,

        },
        {
            -- crowbar
            x=256,
            y=0,
            width=32,
            height=32,

        },
        {
            -- fak
            x=288,
            y=0,
            width=32,
            height=32,

        },
        {
            -- firesuit
            x=320,
            y=0,
            width=32,
            height=32,

        },
        {
            -- flare
            x=352,
            y=0,
            width=32,
            height=32,

        },
        {
            -- flashlight
            x=384,
            y=0,
            width=32,
            height=32,

        },
        {
            -- fuel
            x=416,
            y=0,
            width=32,
            height=32,

        },
        {
            -- generator
            x=448,
            y=0,
            width=32,
            height=32,

        },
        {
            -- gps
            x=480,
            y=0,
            width=32,
            height=32,

        },
        {
            -- junk
            x=512,
            y=0,
            width=32,
            height=32,

        },
        {
            -- katana
            x=544,
            y=0,
            width=32,
            height=32,

        },
        {
            -- kevlar
            x=576,
            y=0,
            width=32,
            height=32,

        },
        {
            -- knife
            x=608,
            y=0,
            width=32,
            height=32,

        },
        {
            -- leather
            x=640,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magazine
            x=672,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magnum
            x=704,
            y=0,
            width=32,
            height=32,

        },
        {
            -- molotov
            x=736,
            y=0,
            width=32,
            height=32,

        },
        {
            -- newspaper
            x=768,
            y=0,
            width=32,
            height=32,

        },
        {
            -- pistol
            x=800,
            y=0,
            width=32,
            height=32,

        },
        {
            -- quiver
            x=832,
            y=0,
            width=32,
            height=32,

        },
        {
            -- radio
            x=864,
            y=0,
            width=32,
            height=32,

        },
        {
            -- rifle
            x=896,
            y=0,
            width=32,
            height=32,

        },
        {
            -- riotsuit
            x=928,
            y=0,
            width=32,
            height=32,

        },
        {
            -- scanner
            x=960,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shell
            x=992,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shotgun
            x=1024,
            y=0,
            width=32,
            height=32,

        },
        {
            -- sledge
            x=1056,
            y=0,
            width=32,
            height=32,

        },
        {
            -- syringe
            x=1088,
            y=0,
            width=32,
            height=32,

        },
        {
            -- terminal
            x=1120,
            y=0,
            width=32,
            height=32,

        },
        {
            -- toolbox
            x=1152,
            y=0,
            width=32,
            height=32,

        },
        {
            -- transmitter
            x=1184,
            y=0,
            width=32,
            height=32,

        },
        {
            -- vaccine
            x=1216,
            y=0,
            width=32,
            height=32,

        },
    },
    
    sheetContentWidth = 1248,
    sheetContentHeight = 32
}

SheetInfo.frameIndex =
{

    ["antidote"] = 1,
    ["bandage"] = 2,
    ["barricade"] = 3,
    ["bat"] = 4,
    ["biosuit"] = 5,
    ["book"] = 6,
    ["bottle"] = 7,
    ["clip"] = 8,
    ["crowbar"] = 9,
    ["fak"] = 10,
    ["firesuit"] = 11,
    ["flare"] = 12,
    ["flashlight"] = 13,
    ["fuel"] = 14,
    ["generator"] = 15,
    ["gps"] = 16,
    ["junk"] = 17,
    ["katana"] = 18,
    ["kevlar"] = 19,
    ["knife"] = 20,
    ["leather"] = 21,
    ["magazine"] = 22,
    ["magnum"] = 23,
    ["molotov"] = 24,
    ["newspaper"] = 25,
    ["pistol"] = 26,
    ["quiver"] = 27,
    ["radio"] = 28,
    ["rifle"] = 29,
    ["riotsuit"] = 30,
    ["scanner"] = 31,
    ["shell"] = 32,
    ["shotgun"] = 33,
    ["sledge"] = 34,
    ["syringe"] = 35,
    ["terminal"] = 36,
    ["toolbox"] = 37,
    ["transmitter"] = 38,
    ["vaccine"] = 39,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
