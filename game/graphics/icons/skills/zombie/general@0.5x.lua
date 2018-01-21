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
            width=64,
            height=64,

        },
        {
            -- cut-palm
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- embrassed-energy
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- evil-hand
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- fat
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- grab
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- heart-organ
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- neck-bite
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- raise-zombie
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- totem-head
            x=576,
            y=0,
            width=64,
            height=64,

        },
    },
    
    sheetContentWidth = 640,
    sheetContentHeight = 64
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
