--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:57aee9a598ac6425f133183df8a86ec0:0e6691dbd933610092c106524d53b905:a41a9cfbabe87f4ee87f6dd690025223$
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
            -- conversation
            x=0,
            y=0,
            width=256,
            height=256,

        },
        {
            -- cut-palm
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- embrassed-energy
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- evil-hand
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- fat
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- grab
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- heart-organ
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- neck-bite
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- raise-zombie
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- totem-head
            x=1024,
            y=256,
            width=256,
            height=256,

        },
    },
    
    sheetContentWidth = 1280,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["conversation"] = 1,
    ["cut-palm"] = 2,
    ["embrassed-energy"] = 3,
    ["evil-hand"] = 4,
    ["fat"] = 5,
    ["grab"] = 6,
    ["heart-organ"] = 7,
    ["neck-bite"] = 8,
    ["raise-zombie"] = 9,
    ["totem-head"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
