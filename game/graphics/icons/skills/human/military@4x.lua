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
            width=512,
            height=512,

        },
        {
            -- fire-axe
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- gavel
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- lighter
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- molotov
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- mp5
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- pistol-gun
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- reticule
            x=1536,
            y=512,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
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
