-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------
local ledNumbers = require("lednumber")
local ledState = require("ledState")

local ledPannel = {}

function ledPannel.new( options )
  local set        = {}
  options          = options              or {}
  set.group        = options.group
  set.x            = options.x            or 0
  set.y            = options.y            or 0
  set.width        = options.width        or 140 -- width of element is 70 number + game state = 140
  set.height       = options.height       or 128 -- height of element is 128
  set.sections     = options.sections     or 4 -- how many elements will be on screen including game state.
  
  set.withFrame    = options.withFrame
  set.frameColor   = options.frameColor   or { 0, 0, 0, 1 }
  set.strokeColor  = options.strokeColor  or { 0.8, 0.8, 1, 1 }
  set.cornerRadius = options.cornerRadius or 0
  set.frame        = nil
  
  set.scoreNumbers = {}
  set.ledState     = nil
  
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
    local pannelWidth = self.width * (self.sections + 1) + self.cornerRadius -- plus one because we have ledState also in pannel
    self.frame = display.newRoundedRect(self.group, 0, 0, pannelWidth, self.height + self.cornerRadius, self.cornerRadius)
    self.frame:setFillColor(0.1, 0.1, 0.1, 1)
    self.frame:setStrokeColor(unpack(set.strokeColor))
    self.frame.strokeWidth = 2
    self.frame.x = self.frame.x + (pannelWidth / 2) - (self.width / 2) - ( self.cornerRadius / 2 )
    self.frame.y = self.frame.y - 1
  end
  
  function set:createGameState()
    local options = 
    {
      group = self.group,
      width = self.width,
      height = self.height,
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
  
  function set:setState( state )
    self.ledState:setState( state )
    if state == "Start" then
      self:blinkingNumbers()
    elseif state == "Reset" then
      self:cancelBlinkNumbers()
    end
  end
  
  create()
  
  return set
  
end

return ledPannel