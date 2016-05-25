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
            width=512,
            height=512,

        },
        {
            -- brain-stem
            x=0,
            y=512,
            width=512,
            height=512,

        },
        {
            -- carnivore-mouth
            x=0,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- carrion
            x=512,
            y=0,
            width=512,
            height=512,

        },
        {
            -- conversation
            x=512,
            y=512,
            width=512,
            height=512,

        },
        {
            -- ent-mouth
            x=512,
            y=1024,
            width=512,
            height=512,

        },
        {
            -- gluttonous-smile
            x=1024,
            y=0,
            width=512,
            height=512,

        },
        {
            -- haunting
            x=1536,
            y=0,
            width=512,
            height=512,

        },
        {
            -- ragged-wound
            x=1024,
            y=512,
            width=512,
            height=512,

        },
        {
            -- sharp-smile
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
