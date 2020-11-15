-----------------------------------------------------------------------------------------
--
-- simpleSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

local clock = os.clock
math.randomseed( os.time() )

local simpleSequence = {}

function simpleSequence.new( options )
  local set = {}
  
  set.options = options or {}
  set.buttons = options.buttons or {}-- a list of game buttons.
  set.ledPannel = options.ledPannel or {}
  handleEndGame = options.handleEndGame
  isPlayerTurn = options.isPlayerTurn
  setTurn = options.setTurn
  set.setScore = options.setScore
  set.getScore = options.getScore
  set.userScore = 0
  set.numSequence = 1
  set.randSequence = {}
  set.userSequence = {}
  set.activateTimer = nil
  
  -- this function called 
  -- First when do reset a game after clear a sequence.
  -- Second After user set correct sequence.
  -- Third when do the first game.
  function set:insertRandomNumberToRandomSequence()
    local var = math.random(#self.buttons)
    table.insert(self.randSequence, var)
  end
  
  -- Called after user press a button.
  function set:isSequencesTheSame( userNumber )
    if self.randSequence[self.numSequence] == userNumber then
      return true
    end
    return false
  end
  
  -- This is the main function with should be run it when we create board
  -- And when we do reset of the game.
  function showSequence( event )
    if isPlayerTurn() == false then
      local thisRect = set.buttons[set.randSequence[set.numSequence]]
      if set.numSequence <= #set.randSequence then
        thisRect:sequenceBlinking()
        set.numSequence = set.numSequence + 1
        set.ledPannel:setState("Play")
      else
        setTurn(true)
        set.numSequence = 1
        set.ledPannel:setState("Record")
      end
    end
  end
  
  -- General function.
  local function cleanSequence( sequence )
    for i=1, #sequence do sequence[i] = nil end
  end
  
  -- Used for reset game.
  function set:cleanGame()
    cleanSequence(self.randSequence)
    cleanSequence(self.userSequence)
    
    setTurn( false )
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
  
  function gameCallbackEvent( id )
    if ( set:isSequencesTheSame(id)) then
      table.insert(set.userSequence, id)
      set.numSequence = set.numSequence + 1
      set.userScore = set.userScore + 1
      set.ledPannel:setScore(set.userScore)
      if #set.userSequence >= #set.randSequence then
        timer.performWithDelay(500, function()
            set.numSequence = 1
            setTurn( false )
            set:insertRandomNumberToRandomSequence()
            cleanSequence(set.userSequence)
          end)
      end
    else
      if set.getScore() < set.userScore then
        set.setScore(set.userScore)
      end
      timer.pause( set.activateTimer )

      set.ledPannel:setState("Start")

      for i = 1, #set.buttons do
        set.buttons[i]:cancel()
        set.buttons[i]:blinkingRepeatedly()
      end
      handleEndGame()

      -- Runtime:addEventListener("touch", resetGame)
    end
  end
  
  local function init()
    for i = 1, #set.buttons do
      set.buttons[i]:setCallback(gameCallbackEvent)
    end
  end
  
  function set:start()
    self.resetGame()
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