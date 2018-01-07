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
            width=256,
            height=256,

        },
        {
            -- claw-slashes
            x=0,
            y=256,
            width=256,
            height=256,

        },
        {
            -- dripping-honey
            x=256,
            y=0,
            width=256,
            height=256,

        },
        {
            -- flaming-claw
            x=256,
            y=256,
            width=256,
            height=256,

        },
        {
            -- grasping-claws
            x=512,
            y=0,
            width=256,
            height=256,

        },
        {
            -- meeple
            x=512,
            y=256,
            width=256,
            height=256,

        },
        {
            -- pierced-body
            x=768,
            y=0,
            width=256,
            height=256,

        },
        {
            -- shieldcomb
            x=768,
            y=256,
            width=256,
            height=256,

        },
        {
            -- spiked-armor
            x=1024,
            y=0,
            width=256,
            height=256,

        },
        {
            -- wolverine-claws
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
