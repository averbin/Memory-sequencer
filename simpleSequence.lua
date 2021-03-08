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
  set.numSequence      = 1
  set.randSequence     = {}
  set.userSequence     = {}
  set.activateTimer    = nil
  
  -- this function called 
  -- First when do reset a game after clear a sequence.
  -- Second After user set correct sequence.
  -- Third when do the first game.
  function set:insertRandomNumberToRandomSequence()
    local var = math.random(#self.buttons)
    table.insert(self.randSequence, var)
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
    if isPlayerTurnCallback() == false then
      local thisRect = set.buttons[set.randSequence[set.numSequence]]
      if set.numSequence <= #set.randSequence then
        thisRect:sequenceBlinking()
        set.numSequence = set.numSequence + 1
        set.ledPannel:setState("Play")
      else
        setTurnCallback( true )
        set.numSequence = 1
        set.ledPannel:setState("Record")
      end
    end
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
    set.numSequence = 1
    set.ledPannel:setScore(set.userScore)
    set.ledPannel:setState("Reset")
    
    for i = 1, #self.buttons do
        self.buttons[i]:cancel()
    end
    
    self.ledPannel:setState("Reset")
  end
  
  function set:resetGame()
    set:cleanGame()
    set:insertRandomNumberToRandomSequence()
    
    if set.activateTimer then
      timer.resume(set.activateTimer)
    else
      set.activateTimer = timer.performWithDelay( 1000, showSequence, 0)
    end
  end
  
  function set:blinkRepeadly()
    for i = 1, #self.buttons do
      self.buttons[i]:cancel()
      self.buttons[i]:blinkingRepeatedly()
    end
  end
  
  function set:finish()
    local missedButton = set:getButtonFromSequence(set.randSequence, set.numSequence)
    local playerButton = set:getButtonFromSequence(set.userSequence, set.numSequence)
    playerButton:cancel()
    playerButton:switchOn()
    transition.to(missedButton, {
        iterations = 4, 
        time = 1000, 
        onComplete = function() 
          playerButton:switchOn() 
          set.ledPannel:setState("Start")
          set:blinkRepeadly() 
          set.endGameCallback() 
        end,
        onRepeat = function() missedButton:sequenceBlinking() end
      }
    )
  end
  
  local function isUserMoreRand()
    return #set.userSequence >= #set.randSequence
  end
  
  local function runNextSequence()
    timer.performWithDelay(500, function()
        set.numSequence = 1
        setTurnCallback( false )
        set:insertRandomNumberToRandomSequence()
        cleanSequence(set.userSequence)
      end)
  end
  
  function gameCallbackEvent( id )
    table.insert(set.userSequence, id)
    if ( #set.userSequence > #set.randSequence ) then
      runNextSequence()
      return
    end
    
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
      timer.pause( set.activateTimer )

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
    set:cleanGame()

    if set.activateTimer then
      timer.cancel(set.activateTimer)
    end
  end

  init()

  return set
end

return simpleSequence