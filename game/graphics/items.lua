--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ddeb8b655530c1155f4fe850b29e894f:feb8674aff1ff0a5e40ee9036891cc3b:1a07471fad41e84a5a5d6e89f55f3227$
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
            -- book
            x=128,
            y=0,
            width=32,
            height=32,

        },
        {
            -- bottle
            x=160,
            y=0,
            width=32,
            height=32,

        },
        {
            -- clip
            x=192,
            y=0,
            width=32,
            height=32,

        },
        {
            -- crowbar
            x=224,
            y=0,
            width=32,
            height=32,

        },
        {
            -- fak
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
            -- junk
            x=480,
            y=0,
            width=32,
            height=32,

        },
        {
            -- katana
            x=512,
            y=0,
            width=32,
            height=32,

        },
        {
            -- knife
            x=544,
            y=0,
            width=32,
            height=32,

        },
        {
            -- leather
            x=576,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magazine
            x=608,
            y=0,
            width=32,
            height=32,

        },
        {
            -- magnum
            x=640,
            y=0,
            width=32,
            height=32,

        },
        {
            -- molotov
            x=672,
            y=0,
            width=32,
            height=32,

        },
        {
            -- newspaper
            x=704,
            y=0,
            width=32,
            height=32,

        },
        {
            -- pistol
            x=736,
            y=0,
            width=32,
            height=32,

        },
        {
            -- quiver
            x=768,
            y=0,
            width=32,
            height=32,

        },
        {
            -- radio
            x=800,
            y=0,
            width=32,
            height=32,

        },
        {
            -- rifle
            x=832,
            y=0,
            width=32,
            height=32,

        },
        {
            -- scanner
            x=864,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shell
            x=896,
            y=0,
            width=32,
            height=32,

        },
        {
            -- shotgun
            x=928,
            y=0,
            width=32,
            height=32,

        },
        {
            -- sledge
            x=960,
            y=0,
            width=32,
            height=32,

        },
        {
            -- syringe
            x=992,
            y=0,
            width=32,
            height=32,

        },
        {
            -- terminal
            x=1024,
            y=0,
            width=32,
            height=32,

        },
        {
            -- toolbox
            x=1056,
            y=0,
            width=32,
            height=32,

        },
        {
            -- transmitter
            x=1088,
            y=0,
            width=32,
            height=32,

        },
        {
            -- vaccine
            x=1120,
            y=0,
            width=32,
            height=32,

        },
    },
    
    sheetContentWidth = 1152,
    sheetContentHeight = 32
}

SheetInfo.frameIndex =
{

    ["antidote"] = 1,
    ["bandage"] = 2,
    ["barricade"] = 3,
    ["bat"] = 4,
    ["book"] = 5,
    ["bottle"] = 6,
    ["clip"] = 7,
    ["crowbar"] = 8,
    ["fak"] = 9,
    ["firesuit"] = 10,
    ["flare"] = 11,
    ["flashlight"] = 12,
    ["fuel"] = 13,
    ["generator"] = 14,
    ["gps"] = 15,
    ["junk"] = 16,
    ["katana"] = 17,
    ["knife"] = 18,
    ["leather"] = 19,
    ["magazine"] = 20,
    ["magnum"] = 21,
    ["molotov"] = 22,
    ["newspaper"] = 23,
    ["pistol"] = 24,
    ["quiver"] = 25,
    ["radio"] = 26,
    ["rifle"] = 27,
    ["scanner"] = 28,
    ["shell"] = 29,
    ["shotgun"] = 30,
    ["sledge"] = 31,
    ["syringe"] = 32,
    ["terminal"] = 33,
    ["toolbox"] = 34,
    ["transmitter"] = 35,
    ["vaccine"] = 36,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
