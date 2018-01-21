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
            width=128,
            height=128,

        },
        {
            -- fire-axe
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- gavel
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- lighter
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- molotov
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- mp5
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pistol-gun
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- reticule
            x=896,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 128
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
