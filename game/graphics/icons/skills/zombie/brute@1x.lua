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
            width=128,
            height=128,

        },
        {
            -- claw-slashes
            x=128,
            y=0,
            width=128,
            height=128,

        },
        {
            -- dripping-honey
            x=256,
            y=0,
            width=128,
            height=128,

        },
        {
            -- flaming-claw
            x=384,
            y=0,
            width=128,
            height=128,

        },
        {
            -- grasping-claws
            x=512,
            y=0,
            width=128,
            height=128,

        },
        {
            -- meeple
            x=640,
            y=0,
            width=128,
            height=128,

        },
        {
            -- pierced-body
            x=768,
            y=0,
            width=128,
            height=128,

        },
        {
            -- shieldcomb
            x=896,
            y=0,
            width=128,
            height=128,

        },
        {
            -- spiked-armor
            x=1024,
            y=0,
            width=128,
            height=128,

        },
        {
            -- wolverine-claws
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
