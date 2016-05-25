--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cc2df7989c5abfd15826666566a45d2b:3bbe086e7b2deabaf86df2e5d923c380:5f6881ff55620094c7ffc467df14f758$
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
            -- blade-bite
            x=0,
            y=0,
            width=64,
            height=64,

        },
        {
            -- claw-slashes
            x=64,
            y=0,
            width=64,
            height=64,

        },
        {
            -- dripping-honey
            x=128,
            y=0,
            width=64,
            height=64,

        },
        {
            -- flaming-claw
            x=192,
            y=0,
            width=64,
            height=64,

        },
        {
            -- grasping-claws
            x=256,
            y=0,
            width=64,
            height=64,

        },
        {
            -- meeple
            x=320,
            y=0,
            width=64,
            height=64,

        },
        {
            -- pierced-body
            x=384,
            y=0,
            width=64,
            height=64,

        },
        {
            -- shieldcomb
            x=448,
            y=0,
            width=64,
            height=64,

        },
        {
            -- spiked-armor
            x=512,
            y=0,
            width=64,
            height=64,

        },
        {
            -- wolverine-claws
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

    ["blade-bite"] = 1,
    ["claw-slashes"] = 2,
    ["dripping-honey"] = 3,
    ["flaming-claw"] = 4,
    ["grasping-claws"] = 5,
    ["meeple"] = 6,
    ["pierced-body"] = 7,
    ["shieldcomb"] = 8,
    ["spiked-armor"] = 9,
    ["wolverine-claws"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
