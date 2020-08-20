-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------
local ledNumbers = require("lednumber")
local ledState = require("ledState")

local ledPanel = {}

function ledPanel.new( options )
  local set        = {}
  options          = options          or {}
  set.group        = options.group
  set.x            = options.x        or 0
  set.y            = options.y        or 0
  set.width        = options.width    or 140 -- width of element is 70 number + game state = 140
  set.height       = options.height   or 128 -- height of element is 128
  set.sections     = options.sections or 4 -- how many elements will be on screen including game state.
  
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

return ledPanel