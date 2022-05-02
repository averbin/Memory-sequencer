-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------
local ledNumbers = require("lednumber")
local ledState = require("ledState")
local colors = require("colors")

local ledPannel = {}

function ledPannel.new( options )
  local set         = {}
  options           = options               or {}
  set.group         = options.group
  set.x             = options.x             or 0
  set.y             = options.y             or 0
  set.widthElement  = options.widthElement  or 70 -- width of element
  set.heightElement = options.heightElement or 128 -- height of element
  set.sections      = options.sections      or 4 -- how many elements will be on screen including game state.
  
  set.withFrame     = options.withFrame
  set.frameColor    = options.frameColor    or { 0, 0, 0, 1 }
  set.strokeColor   = options.strokeColor   or { unpack(colors['strokeColorButton']) }
  set.cornerRadius  = options.cornerRadius  or 0
  set.frame         = nil
  
  set.scoreNumbers  = {}
  set.ledState      = nil
  
  function createLedNumber(x, y, number)
    local options = 
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
  
  function set:createFrame()
    local pannelWidth = self.widthElement * (self.sections + 1) + self.cornerRadius -- plus one because we have ledState also in pannel
    self.frame = display.newRoundedRect(self.group, 0, 0, pannelWidth
      , self.heightElement + self.cornerRadius, self.cornerRadius)
    local frameColor = d8gitToArithmetic({51.0, 0.0, 0.0})
    frameColor[#frameColor + 1] = 1.0
    self.frame:setFillColor(unpack(frameColor))
    self.frame:setStrokeColor(unpack(set.strokeColor))
    self.frame.strokeWidth = 4
  end
  
  function set:createGameState()
    local options = 
    {
      group = self.group,
      width = self.widthElement,
      height = self.heightElement,
      x = - ((self.widthElement * ( self.sections + 1 )) / 2 - (self.widthElement / 2))
    }
    self.ledState = ledState.new( options )
  end
  
  function set:createNumbers()
    for i = 1, set.sections do
      local x = self.ledState.x + (self.ledState.width * i)
      local y = self.ledState.y
      self.scoreNumbers[i] = createLedNumber( x, y, i)
    end
  end
  
  function set:setupGroup()
    self.group:scale(0.6, 0.6)
    self.group.x = self.x
    self.group.y = self.y
  end
  
  local function create()
    if set.withFrame then
      set:createFrame()
    end
    set:createGameState()
    set:createNumbers()
    set:setupGroup()
  end
  
  local function convertUserScore( userScore )
    local userScoreStr = tostring(userScore)
    local numbers = {}
    local maxScore = 4
  
    for i = #userScoreStr, 1, -1 do
      numbers[maxScore] = tonumber(string.char(string.byte(tostring(userScore), i)))
      maxScore = maxScore - 1
    end
  
    for i = 1, maxScore do
      numbers[i] = 0
    end

    return numbers
  end
  
  function set:setScore( score )
    tab = convertUserScore(score)
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
  
  function set:setState( state )
    self.ledState:setState( state )
    if state == "Start" then
      self:blinkingNumbers()
    elseif state == "Reset" then
      self:cancelBlinkNumbers()
    end
  end
  
  function set:setWidth( width )
    self.group.width = width
  end
  
  function set:setHeight( height )
    self.group.height = height
  end
  
  create()
  
  return set
  
end

return ledPannel