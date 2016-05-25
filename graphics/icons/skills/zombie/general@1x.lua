--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:476b16d902c6b3dda2b67edd865a0000:9a8be4fd741dd7d04c3e1bf3347a50fb:a41a9cfbabe87f4ee87f6dd690025223$
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
            -- dna1
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- embrassed-energy
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- evil-hand
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- gluttony
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- grab
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- heart-organ
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pointing
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- swallow
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- terror
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- totem-head
            x=1152,
            y=0,
            width=128,
            height=128,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["dna1"] = 1,
    ["embrassed-energy"] = 2,
    ["evil-hand"] = 3,
    ["gluttony"] = 4,
    ["grab"] = 5,
    ["heart-organ"] = 6,
    ["pointing"] = 7,
    ["swallow"] = 8,
    ["terror"] = 9,
    ["totem-head"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
