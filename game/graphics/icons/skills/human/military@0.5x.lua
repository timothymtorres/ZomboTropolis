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
            width=64,
            height=64,

        },
        {
            -- bowie-knife
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- bowman
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- bullets
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- crossed-slashes
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fire-axe
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- gavel
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- molotov
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- mp5
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- pistol-gun
            x=576,
            y=0,
            width=64,
            height=64,

        },
        {
            -- reticule
            x=640,
            y=0,
            width=64,
            height=64,

        },
        {
            -- spade
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
