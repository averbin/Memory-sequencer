-----------------------------------------------------------------------------------------
--
-- shapeSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------
local colors = require("colors")

local clock = os.clock
math.randomseed( os.time() )

local shapeSequence = {}

function shapeSequence.new( options )
  local set = {}
  
  set.options          = options                      or {}
  set.buttons          = options.buttons              or {}
  set.ledPannel        = options.ledPannel            or {}
  set.endGameCallback  = options.endGameCallback      or {}
  isPlayerTurnCallback = options.isPlayerTurnCallback or {}
  setTurnCallback      = options.setTurnCallback      or {}
  set.setScoreCallback = options.setScoreCallback     or {}
  set.getScoreCallback = options.getScoreCallback     or {}
  set.rows             = options.rows                 or 0
  set.columns          = options.columns              or 0
  set.userScore        = 0
  set.numSequence      = 1
  set.randSequence     = {}
  set.userSequence     = {}
  set.activateTimer    = nil
  set.timerDelay       = 1000
  
  function isExistsElement ( array, element )
    for i = 1, #array do
      if array[i] == element then
        return true
      end
    end
    return false
  end
  
  function set:insertSequence()
    for i = 1, self.numSequence do
      while true do 
        local var = math.random(#self.buttons)
        if not isExistsElement(self.randSequence, var) then
          table.insert(self.randSequence, var)
          break
        end
      end
    end
  end
  
  local function cleanSequence( sequence )
    for i=1, #sequence do sequence[i] = nil end
  end
  
  function set:cleanGame()
    cleanSequence(self.randSequence)
    cleanSequence(self.userSequence)
    
    setTurnCallback( false )
    set.userScore = 0
    set.numSequence = 1
    
    set.ledPannel:setScore(set.userScore)
    set.ledPannel:setState("Reset")
    
    for i = 1, #self.buttons do
        self.buttons[i]:cancel()
    end
    
    self.ledPannel:setState("Reset")
  end
  
  function showButtons()
    for i = 1, #set.randSequence do 
      set.buttons[set.randSequence[i]]:switchOn()
    end
    set.ledPannel:setState("Play")
  end
  
  function hideButtons()
    for i = 1, #set.randSequence do 
      set.buttons[set.randSequence[i]]:switchOff()
    end
    set.ledPannel:setState("Record")
  end
  
  function hideAllButtons()
    for i = 1, #set.buttons do 
      set.buttons[i]:switchOff()
    end
  end
  
  function showSequence( event )
    if isPlayerTurnCallback() == false then
      transition.to(set, 
        {
          time = 1000,
          onStart = showButtons,
          onComplete = function() hideButtons(); setTurnCallback( true ) end,
          iterations = 1
        }
      )
    end
  end
  
  function set:nextStep()
    set.activatedTimer = timer.performWithDelay( set.timerDelay, showSequence, #set.randSequence + 1)
  end
  
  function set:resetGame()
    self:cleanGame()
    self:insertSequence()
    
    if self.activateTimer then
      timer.resume(set.activateTimer)
    else
      self.timerDelay = 1000
      self.activateTimer = timer.performWithDelay( self.timerDelay, showSequence, 1)
    end
    self:nextStep()
  end
  
  function set:start()
    self:resetGame()
  end
  
  function set:stop()
    self:cleanGame()

    if self.activatedTimer and self.activatedTimer._expired == false then
      timer.cancel(self.activateTimer)
    end
  end
  
  -- Get button from list
  function set:getButtonFromSequence(sequence, buttonID)
    return self.buttons[sequence[buttonID]]
  end
  
  function set:getButtonsFromSequence(sequence, buttonIDs)
    local missedButtons = {}
    
    for i = 1, #buttonIDs do
      table.insert(missedButtons, self.buttons[buttonIDs[i]])
    end
    
    return missedButtons
  end
  
  function set:blinkRepeadly()
    for i = 1, #self.buttons do
      self.buttons[i]:cancel()
      self.buttons[i]:blinkingRepeatedly()
    end
  end
  
  function set:setDifference( randSequence, userSequence )
    local diff = {}
    local z = 1
    
    if userSequence[1] == userSequence[#userSequence] then
      diff = table.copy(randSequence)
      return diff
    end
    
    for x = 1 , #randSequence do
      local found = false
      
      for y = 1 , #userSequence do
        if randSequence[x] == userSequence[y] then
          found = true
        end
      end
      
      if not found then
        diff[z] = randSequence[x]
        z = z + 1
      end
      
    end
    
    return diff
  end
  
  function set:finish()
    setTurnCallback( false )
    local diff = self:setDifference(self.randSequence, self.userSequence)
    local missedButtons = self:getButtonsFromSequence(self.randSequence, diff)
    local playerButton = self:getButtonFromSequence(self.userSequence, #self.userSequence)
    playerButton:cancel()
    playerButton:switchOn()
    transition.to(missedButtons, {
        iterations = 3, 
        time = 1000, 
        onComplete = function() 
          playerButton:switchOn() 
          set.ledPannel:setState("Start")
          set:blinkRepeadly() 
          set.endGameCallback() 
          set.numSequence = 1
        end,
        onRepeat = function()
          for i = 1, #missedButtons do
            missedButtons[i]:sequenceBlinking()
          end
        end
      }
    )
  end

  function set:findInRandomSequence( button )
    local id = tonumber(button.id)
    for i = 1, #self.randSequence do
      if id == self.randSequence[i] then
        return true
      end
    end
    return false
  end
  
  local function runNextSequence()
    setTurnCallback( false )
    cleanSequence(set.randSequence)
    cleanSequence(set.userSequence)
    hideAllButtons()
    
    set:insertSequence()
    set.timerDelay = set.timerDelay - 1
    set.activatedTimer = timer.performWithDelay( set.timerDelay, showSequence, 1)
  end

  local function gameCallbackEvent( button )
    local id = tonumber(button.id)
    if ( not isExistsElement(set.userSequence, id) ) then
      table.insert(set.userSequence, id)
      button:switchOn()
      button:vibrate()
    end
    
    if ( isExistsElement(set.randSequence, id)) then
      if( #set.randSequence == #set.userSequence ) then
        setTurnCallback( false )
        set.numSequence = set.numSequence + 1
        set.userScore = set.userScore + 1
        set.ledPannel:setScore(set.userScore)
        if set.numSequence >= 25 then
          set:resetGame()
          return
        end
        transition.to( set, { delay = 500, onComplete = function() runNextSequence() end })
      end
    else
      if set.getScoreCallback() < set.userScore then
        set.setScoreCallback(set.userScore)
      end
      set:finish()
    end
  end

  function set:init()
    for i = 1, #set.buttons do
      set.buttons[i]:setColor( d8gitToArithmetic(colors[game.type][1]) )
      set.buttons[i]:setCallback(gameCallbackEvent)
    end
  end
  
  set:init()
  
  return set
end

return shapeSequence