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
            width=512,
            height=512,

        },
        {
            -- cut-palm
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- embrassed-energy
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- evil-hand
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- fat
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- grab
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- heart-organ
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- neck-bite
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- raise-zombie
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
