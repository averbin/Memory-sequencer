-----------------------------------------------------------------------------------------
--
-- simpleSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

local clock = os.clock
math.randomseed( os.time() )

local simpleSequence = {}

function simpleSequence.new( options )
  local set            = {}
  
  set.options          = options                      or {}
  set.buttons          = options.buttons              or {} -- a list of game buttons.
  set.ledPannel        = options.ledPannel            or {}
  set.endGameCallback  = options.endGameCallback      or {}
  isPlayerTurnCallback = options.isPlayerTurnCallback or {}
  setTurnCallback      = options.setTurnCallback      or {}
  set.setScoreCallback = options.setScoreCallback     or {}
  set.getScoreCallback = options.getScoreCallback     or {}
  set.userScore        = 0
  set.numSequence      = 0
  set.randSequence     = {}
  set.userSequence     = {}
  set.activatedTimer   = nil
  set.timerDelay       = 1000
  
  -- this function called 
  -- First when do reset a game after clear a sequence.
  -- Second After user set correct sequence.
  -- Third when do the first game.
  function set:insertRandomNumberToRandomSequence()
    local var = math.random(#self.buttons)
    table.insert(self.randSequence, var)
    self.numSequence = #self.randSequence
  end
  
  -- Called after user press a button.
  -- Check is sequince the same.
  function set:isSequencesTheSame( userNumber )
    if not self.randSequence[self.numSequence] then
      assert("ERROR: no randSequence exists!")
    end
    if self.randSequence[self.numSequence] == userNumber then
      return true
    end
    return false
  end
  
  -- This is the main function with should be run it when we create board
  -- And when we do reset of the game.
  function showSequence( event )
    set.numSequence = event.count
    local thisRect = set.buttons[set.randSequence[set.numSequence]]
    if set.numSequence <= #set.randSequence then
      thisRect:sequenceBlinking()
      set.ledPannel:setState("Play")
    end
    
    if set.numSequence >= #set.randSequence then
      setTurnCallback( true )
      set.numSequence = 1
    end
  end
  
  function completeSequence( event )
    setTurnCallback( true )
    set.numSequence = 0
    set.ledPannel:setState("Record")
  end
  
  -- Clear array of numbers which is store in sequences.
  local function cleanSequence( sequence )
    for i=1, #sequence do sequence[i] = nil end
  end
  
  -- Get button from list
  function set:getButtonFromSequence(sequence, buttonID)
    return self.buttons[sequence[buttonID]]
  end
  
  -- Used for reset game.
  function set:cleanGame()
    cleanSequence(self.randSequence)
    cleanSequence(self.userSequence)
    
    setTurnCallback( false )
    set.userScore = 0
    set.numSequence = 0
    set.ledPannel:setScore(set.userScore)
    set.ledPannel:setState("Reset")
    
    for i = 1, #self.buttons do
        self.buttons[i]:cancel()
    end
    
    self.ledPannel:setState("Reset")
  end
  
  function set:resetGame()
    self:cleanGame()
    self:insertRandomNumberToRandomSequence()
    self.timerDelay = 1000
    
    self.activatedTimer = timer.performWithDelay( self.timerDelay, showSequence, #self.randSequence)

  end
  
  function set:blinkRepeadly()
    for i = 1, #self.buttons do
      self.buttons[i]:cancel()
      self.buttons[i]:blinkingRepeatedly()
    end
  end
  
  function set:finish()
    setTurnCallback( false )
    local missedButton = set:getButtonFromSequence(set.randSequence, set.numSequence)
    local playerButton = set:getButtonFromSequence(set.userSequence, set.numSequence)
    playerButton:cancel()
    playerButton:switchOn()
    transition.to(missedButton, {
        iterations = 3, 
        time = 1000, 
        onComplete = function() 
          playerButton:switchOn() 
          set.ledPannel:setState("Start")
          set:blinkRepeadly() 
          set.endGameCallback() 
          set.numSequence = 0
        end,
        onRepeat = function() missedButton:sequenceBlinking() end
      }
    )
  end
  
  local function isUserMoreRand()
    return #set.userSequence == #set.randSequence
  end
  
  local function runNextSequence()
    setTurnCallback( false )
    set.numSequence = 0
    set:insertRandomNumberToRandomSequence()
    cleanSequence(set.userSequence)
    set.timerDelay = set.timerDelay - 1
    set.activatedTimer = timer.performWithDelay( set.timerDelay, showSequence, #set.randSequence)
  end
  
  function gameCallbackEvent( button )
    local id = tonumber(button.id)
    table.insert(set.userSequence, id)
    button:blink()
    if ( set:isSequencesTheSame(id)) then
      set.numSequence = set.numSequence + 1
      set.userScore = set.userScore + 1
      set.ledPannel:setScore(set.userScore)
      if ( isUserMoreRand() ) then
        runNextSequence()
      end
    else
      if set.getScoreCallback() < set.userScore then
        set.setScoreCallback(set.userScore)
      end

      set:finish()
    end
  end
  
  local function init()
    for i = 1, #set.buttons do
      set.buttons[i]:setCallback(gameCallbackEvent)
    end
  end
  
  function set:start()
    self:resetGame()
  end
  
  function set:stop()
    self:cleanGame()

    if self.activatedTimer and self.activatedTimer._expired == false then
      timer.cancel(set.activateTimer)
    end
  end

  init()

  return set
end

return simpleSequence