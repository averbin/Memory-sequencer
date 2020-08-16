-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------
local ledNumbers = require("lednumber")

local ledPanel = {}

function ledPanel.new( options )
  local set                 = {}
  options                   = options          or {}
  set.group                 = options.group
  set.x                     = options.x        or 0
  set.y                     = options.y        or 0
  set.width                 = options.width    or 140 -- width of element is 70 number + game state = 140
  set.height                = options.height   or 128 -- height of element is 128
  set.sections              = options.sections or 4 -- how many elements will be on screen including game state.
  
  set.backgroundCell        = nil
  set.playImg               = nil
  set.isPlayRunning         = false
  set.recordImg             = nil
  set.isRecordRunning       = false
  set.scoreNumbers          = {}
  
  function createLedNumber(x, y, number)
    options = 
    {
      group = set.group,
      x = x, 
      y = y,
      width = set.width,
      height = set.height,
      backgroundImg = "img/numbers/background.png",
      stencilImg = "img/numbers/no_number.png",
      number = number
    }
    local num = ledNumber.new( options )
    return num
  end
  
  function set:createGameState()
    self.backgroundCell = display.newImageRect(self.group, "img/play_panel.png",
      self.width, self.height)
    
    self.playImg = display.newImageRect(self.group, "img/play_on.png",
      self.width, self.height)
    self.playImg.isVisible = false
    
    self.recordImg = display.newImageRect(self.group, "img/Record_on.png",
      self.width, self.height)
    self.recordImg.isVisible = false
  end
  
  function set:createNumbers()
    for i = 1, set.sections do
      self.scoreNumbers[i] = createLedNumber(self.backgroundCell.x + (self.backgroundCell.width * i), self.backgroundCell.y, i)
    end
  end
  
  function set:setupGroup()
    self.group:scale(0.6, 0.6)
    self.group.x = self.x
    self.group.y = self.y
  end
  
  local function create()
    set:createGameState()
    set:createNumbers()
    set:setupGroup()
  end
  
  local function visability( obj, state)
    if obj.isVisible ~= state then
      obj.isVisible = state
      if state == true then
        obj.alpha = 1.0
      else
        obj.alpha = 0.0
      end
    end
  end
  
  local function blink( obj )
    visability(obj, true)
    transition.blink( obj , { time=2000 }) 
  end
  
  local function cancel( obj )
    visability(obj, false)
    transition.cancel( obj )
  end
  
  function set:blinkPlay()
    if self.isPlayRunning == false then
      blink(self.playImg)
      self.isPlayRunning = true
    end
  end
  
  function set:cancelPlay()
    if self.isPlayRunning == true then
      cancel(self.playImg)
      self.isPlayRunning = false
    end
  end
  
  function set:blinkRecord()
    if self.isRecordRunning == false then
      blink(self.recordImg)
      self.isRecordRunning = true
    end
  end

  function set:cancelRecord()
    if self.isRecordRunning == true then
      cancel(self.recordImg)
      self.isRecordRunning = false
    end
  end
  
  function set:setScore( tab )
    for i = 1, #tab do
      self.scoreNumbers[i]:setNumById(tab[i])
    end
  end
  
  function set:blinkingNumbers()
    for i = 1, #self.scoreNumbers do
      self.scoreNumbers[i]:blinking()
    end
  end
  
  function set:cancelBlinkNumbers()
    for i = 1, #self.scoreNumbers do
      self.scoreNumbers[i]:cancel()
    end
  end
  
  create()
  
  return set
  
end

return ledPanel