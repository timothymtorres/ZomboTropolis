--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:12384fff934bc973c23fbb8584bf28cc:53e8fa724c7d602911d05db57846716d:1a07471fad41e84a5a5d6e89f55f3227$
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
            -- FAK
            x=0,
            y=0,
            width=32,
            height=32,

        },
        {
            -- antidote
            x=32,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bandage
            x=64,
            y=0,
            width=32,
            height=32,

        },
        {
            -- barricade
            x=96,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bat
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
            -- firesuit
            x=288,
            y=0,
            width=32,
            height=32,

        },
        {
            -- flare
            x=320,
            y=0,
            width=32,
            height=32,

        },
        {
            -- flashlight
            x=352,
            y=0,
            width=32,
            height=32,

        },
        {
            -- fuel
            x=384,
            y=0,
            width=32,
            height=32,

        },
        {
            -- generator
            x=416,
            y=0,
            width=32,
            height=32,

        },
        {
            -- gps
            x=448,
            y=0,
            width=32,
            height=32,

        },
        {
            -- katana
            x=480,
            y=0,
            width=32,
            height=32,

        },
        {
            -- knife
            x=512,
            y=0,
            width=32,
            height=32,

        },
        {
            -- leather
            x=544,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magazine
            x=576,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magnum
            x=608,
            y=0,
            width=32,
            height=32,

        },
        {
            -- molotov
            x=640,
            y=0,
            width=32,
            height=32,

        },
        {
            -- newspaper
            x=672,
            y=0,
            width=32,
            height=32,

        },
        {
            -- pistol
            x=704,
            y=0,
            width=32,
            height=32,

        },
        {
            -- quiver
            x=736,
            y=0,
            width=32,
            height=32,

        },
        {
            -- radio
            x=768,
            y=0,
            width=32,
            height=32,

        },
        {
            -- rifle
            x=800,
            y=0,
            width=32,
            height=32,

        },
        {
            -- scanner
            x=832,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shell
            x=864,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shotgun
            x=896,
            y=0,
            width=32,
            height=32,

        },
        {
            -- sledge
            x=928,
            y=0,
            width=32,
            height=32,

        },
        {
            -- syringe
            x=960,
            y=0,
            width=32,
            height=32,

        },
        {
            -- terminal
            x=992,
            y=0,
            width=32,
            height=32,

        },
        {
            -- toolbox
            x=1024,
            y=0,
            width=32,
            height=32,

        },
        {
            -- transmitter
            x=1056,
            y=0,
            width=32,
            height=32,

        },
        {
            -- vaccine
            x=1088,
            y=0,
            width=32,
            height=32,

        },
    },
    
    sheetContentWidth = 1120,
    sheetContentHeight = 32
}

SheetInfo.frameIndex =
{

    ["FAK"] = 1,
    ["antidote"] = 2,
    ["bandage"] = 3,
    ["barricade"] = 4,
    ["bat"] = 5,
    ["book"] = 6,
    ["bottle"] = 7,
    ["clip"] = 8,
    ["crowbar"] = 9,
    ["firesuit"] = 10,
    ["flare"] = 11,
    ["flashlight"] = 12,
    ["fuel"] = 13,
    ["generator"] = 14,
    ["gps"] = 15,
    ["katana"] = 16,
    ["knife"] = 17,
    ["leather"] = 18,
    ["magazine"] = 19,
    ["magnum"] = 20,
    ["molotov"] = 21,
    ["newspaper"] = 22,
    ["pistol"] = 23,
    ["quiver"] = 24,
    ["radio"] = 25,
    ["rifle"] = 26,
    ["scanner"] = 27,
    ["shell"] = 28,
    ["shotgun"] = 29,
    ["sledge"] = 30,
    ["syringe"] = 31,
    ["terminal"] = 32,
    ["toolbox"] = 33,
    ["transmitter"] = 34,
    ["vaccine"] = 35,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
