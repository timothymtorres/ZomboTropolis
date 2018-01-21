--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:84e9f1b46a9e490d2ca1344f7b6900d6:c79c72893007145e86af7fdebb9a4413:755de0facc9b590f6bd6b331ea08eb7f$
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
            -- crossed-slashes
            x=0,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fire-axe
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- gavel
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- lighter
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- molotov
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- mp5
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- pistol-gun
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- reticule
            x=448,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["crossed-slashes"] = 1,
    ["fire-axe"] = 2,
    ["gavel"] = 3,
    ["lighter"] = 4,
    ["molotov"] = 5,
    ["mp5"] = 6,
    ["pistol-gun"] = 7,
    ["reticule"] = 8,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
