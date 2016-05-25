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
            width=512,
            height=512,

        },
        {
            -- bowie-knife
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- bowman
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- bullets
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- crossed-slashes
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- fire-axe
            x=0,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- gavel
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- molotov
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- mp5
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- pistol-gun
            x=512,
            y=1536,
            width=512,
            height=512,

        },
        {
            -- reticule
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- spade
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
