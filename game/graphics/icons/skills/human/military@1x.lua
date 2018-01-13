--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e6f2e98c058b304fefb3d0ec7ae55a6b:81d4f9021e987f3a1c23864779b383ac:755de0facc9b590f6bd6b331ea08eb7f$
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
            -- archery-target
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- bowie-knife
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- bowman
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- bullets
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- crossed-slashes
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- fire-axe
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- gavel
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- molotov
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- mp5
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pistol-gun
            x=1152,
            y=0,
            width=128,
            height=128,

        },
        {
            -- reticule
            x=1280,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spade
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

    ["archery-target"] = 1,
    ["bowie-knife"] = 2,
    ["bowman"] = 3,
    ["bullets"] = 4,
    ["crossed-slashes"] = 5,
    ["fire-axe"] = 6,
    ["gavel"] = 7,
    ["molotov"] = 8,
    ["mp5"] = 9,
    ["pistol-gun"] = 10,
    ["reticule"] = 11,
    ["spade"] = 12,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
