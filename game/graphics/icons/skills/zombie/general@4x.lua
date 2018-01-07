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
            width=512,
            height=512,

        },
        {
            -- embrassed-energy
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- evil-hand
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- gluttony
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- grab
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- heart-organ
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- pointing
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- swallow
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- terror
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- totem-head
            x=1024,
            y=1024,
            width=512,
            height=512,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1536
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
