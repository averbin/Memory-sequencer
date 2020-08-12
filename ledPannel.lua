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
  local playImg         = nil
  local isPlayRunning   = false
  local recordImg       = nil
  local isRecordRunning = false
  local scoreNumbers = {}
  
  local function createLedNumber(x, y, id)
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
      id = id
    }

    return ledNumber.new( options )
  end
  
  local function createGameState()
    backgroundCell = display.newImageRect(group, "img/play_panel.png", width, height)
    playImg = display.newImageRect(group, "img/play_on.png", width, height)
    playImg.isVisible = false
    recordImg = display.newImageRect(group, "img/Record_on.png", width, height)
    recordImg.isVisible = false
    for i = 1, sections do
      scoreNumbers[i] = createLedNumber(backgroundCell.x + (backgroundCell.width * i), backgroundCell.y, 0)
    end

    --ledPanel:blinkPlay()
    --ledPanel:blinkRect()
    group:scale(0.6, 0.6)
    group.x = x - width / 2
    group.y = y
  end
  
  function visability( obj, state)
    if obj.isVisible ~= state then
      obj.isVisible = state
      if state == true then
        obj.alpha = 1.0
      else
        obj.alpha = 0.0
      end
    end
  end
  
  function blink( obj )
    visability(obj, true)
    transition.blink( obj , { time=2000 }) 
  end
  
  function cancel( obj )
    visability(obj, false)
    transition.cancel( obj )
  end
  
  function ledPanel:blinkPlay()
    if isPlayRunning == false then
      blink(playImg)
      isPlayRunning = true
    end
  end
  
  function ledPanel:cancelPlay()
    if isPlayRunning == true then
      cancel(playImg)
      isPlayRunning = false
    end
  end
  
  function ledPanel:blinkRecord()
    if isRecordRunning == false then
      blink(recordImg)
      isRecordRunning = true
    end
  end

  function ledPanel:cancelRecord()
    if isRecordRunning == true then
      cancel(recordImg)
      isRecordRunning = false
    end
  end
  
  function ledPanel:setScore( tab )
    for i = 1, #tab do
      print("table value: " .. tab[i])
      --scoreNumbers[i].setNumById(tab[i])
      display.remove( scoreNumbers[i].numberImg )
      print(type(scoreNumbers[i].group))
      print(numbers[tab[i]].path)
      print( scoreNumbers[i].width, scoreNumbers[i].height)
      print(scoreNumbers[i].x_, scoreNumbers[i].y_)
      scoreNumbers[i].numberImg = display.newImageRect(scoreNumbers[i].group, numbers[tab[i]].path, scoreNumbers[i].width, scoreNumbers[i].height)
      scoreNumbers[i].numberImg.x = scoreNumbers[i].x_
      scoreNumbers[i].numberImg.y = scoreNumbers[i].y_
    end
  end
  
  createGameState()
  
end

return ledPanel