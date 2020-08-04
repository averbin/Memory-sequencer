-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------
local numbers = require("numbers")
local ledNumbers = require("lednumber")

ledPanel = {}

function ledPanel.new( options )
  options               = options          or {}
  group                 = options.group
  x                     = options.x        or 0
  y                     = options.y        or 0
  width                 = options.width    or 140 -- width of element is 70 number + game state = 140
  height                = options.height   or 128 -- height of element is 128
  sections              = options.sections or 4 -- how many elements will be on screen including game state.
  
  local backgroundCell  = nil
  local play            = nil
  local record          = nil
  
  local function createLedNumber(x, y)
    options = 
    {
      group = group,
      x = x, 
      y = y,
      width = width,
      height = height,
      backgroundImg = "img/numbers/background.png",
      stencilImg = "img/numbers/no_number.png",
      numbers = numbers,
      id = 1
    }

    return ledNumber.new( options )
  end
  
  local function createGameState()
    backgroundCell = display.newImageRect(group, "img/play_panel.png", width, height)
    --backgroundCell.x = x; backgroundCell.y = y
    play = display.newImageRect(group, "img/play_on.png", width, height)
    --play.x = x; play.y = y
    record = display.newImageRect(group, "img/Record_on.png", width, height)
    --record.x = x; record.y = y
    for i = 1, sections do
      createLedNumber(backgroundCell.x + (backgroundCell.width * i), backgroundCell.y)
    end

    ledPanel:blinkPlay()
    ledPanel:blinkRect()
    group:scale(0.6, 0.6)
    group.x = x - width / 2
    group.y = y
  end
  
  function ledPanel:blinkPlay()
    transition.blink( play , { time=2000 }) 
  end
  
   function ledPanel:blinkRect()
    transition.blink( record , { time=2000 }) 
  end
  
  function ledPanel:getRecord()
    return record
  end
  
  createGameState()
  
end

return ledPanel