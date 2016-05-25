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
            width=64,
            height=64,

        },
        {
            -- brain-stem
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- carnivore-mouth
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- carrion
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- conversation
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- ent-mouth
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- gluttonous-smile
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- haunting
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- ragged-wound
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- sharp-smile
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
