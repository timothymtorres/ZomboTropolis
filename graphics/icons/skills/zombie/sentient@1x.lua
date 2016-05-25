--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f82ee7a24c61085f3fe8ba7d49aae1f6:5b3e56fa3d29d26152e44139ff493177:f152f4d0bf9c3e71d3367157aab64e48$
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
            -- barefoot
            x=0,
            y=0,
            width=128,
            height=128,

        },
        {
            -- brain-stem
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- carnivore-mouth
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- carrion
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- conversation
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- ent-mouth
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- gluttonous-smile
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- haunting
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- ragged-wound
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- sharp-smile
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

    ["barefoot"] = 1,
    ["brain-stem"] = 2,
    ["carnivore-mouth"] = 3,
    ["carrion"] = 4,
    ["conversation"] = 5,
    ["ent-mouth"] = 6,
    ["gluttonous-smile"] = 7,
    ["haunting"] = 8,
    ["ragged-wound"] = 9,
    ["sharp-smile"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
