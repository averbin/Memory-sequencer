--
-- created with TexturePacker - https://www.codeandweb.com/texturepacker
--
-- $TexturePacker:SmartUpdate:77cff01c6dc0d466ab312eb302d78102:afdbc696685cde86e77f1b80b3eb7b62:4825cd60130e5d662d81fae4cd903613$
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
            -- 0
            x=0,
            y=0,
            width=70,
            height=128,

        },
        {
            -- 1
            x=70,
            y=0,
            width=70,
            height=128,

        },
        {
            -- 2
            x=140,
            y=0,
            width=70,
            height=128,

        },
        {
            -- 3
            x=210,
            y=0,
            width=70,
            height=128,

        },
        {
            -- 4
            x=280,
            y=0,
            width=70,
            height=128,

        },
        {
            -- 5
            x=0,
            y=128,
            width=70,
            height=128,

        },
        {
            -- 6
            x=70,
            y=128,
            width=70,
            height=128,

        },
        {
            -- 7
            x=140,
            y=128,
            width=70,
            height=128,

        },
        {
            -- 8
            x=210,
            y=128,
            width=70,
            height=128,

        },
        {
            -- 9
            x=280,
            y=128,
            width=70,
            height=128,

        },
        {
            -- background
            x=0,
            y=256,
            width=70,
            height=128,

        },
        {
            -- no_number
            x=70,
            y=256,
            width=70,
            height=128,

        },
        {
            -- play_on
            x=140,
            y=256,
            width=70,
            height=128,

        },
        {
            -- play_panel
            x=210,
            y=256,
            width=70,
            height=128,

        },
        {
            -- Record_on
            x=280,
            y=256,
            width=70,
            height=128,

        },
    },

    sheetContentWidth = 350,
    sheetContentHeight = 384
}

SheetInfo.frameIndex =
{

    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
    ["6"] = 7,
    ["7"] = 8,
    ["8"] = 9,
    ["9"] = 10,
    ["background"] = 11,
    ["no_number"] = 12,
    ["play_on"] = 13,
    ["play_panel"] = 14,
    ["Record_on"] = 15,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
