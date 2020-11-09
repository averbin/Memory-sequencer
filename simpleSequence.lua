-----------------------------------------------------------------------------------------
--
-- simpleSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

local simpleSequence = {}

function simpleSequence.new( options )
  local set = {}
  
  set.options = options or {}
  set.rects = set.options.rectungles or {}-- a list of game buttons.
  set.buttons = #set.rects -- count of buttons in the game
  set.numSequence = 1
  set.randSequence = {}
  set.userSequence = {}
  
  -- this function called 
  -- First when do reset a game after clear a sequence.
  -- Second After user set correct sequence.
  -- Third when do the first game.
  function set:insertRandomNumberToRandomSequence()
    local var = math.random(self.buttons)
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
  function set:showSequence( event )
    if game.isPlayer == false then
      local thisRect = rects[self.randSequence[self.numSequence]]
      if self.numSequence <= #self.randSequence then
        thisRect:sequenceBlinking()
        self.numSequence = self.numSequence + 1
        ledPannel:setState("Play")
      else
        game.isPlayer = true
        self.numSequence = 1
        ledPannel:setState("Record")
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
    --if userScore > gameScores[game.type] then
    --  gameScores[game.type] = userScore
    --  loadsave.saveTable( gameScores, "settings.json")
    --end
    
    --numSequence = 1
    --userScore = 0
    --ledPannel:setScore(userScore)
    --game.isPlayer = false
    
    --[[for i = 1, #rects do
      rects[i]:cancel()
    end]]
    
    --ledPannel:setState("Reset")
  end
  
  -- Uses for reset game.
  function set:resetGame( event )
    if event.phase == "began" then
      
      self.cleanGame()
      
      self.insertRandomNumberToRandomSequence()
      
      --[[if activateTimer then
        timer.resume(activateTimer)
      else
        activateTimer = timer.performWithDelay( 1000, showSequence, 0)
      end
      
      Runtime:removeEventListener( "touch", resetGame ) ]]
      return true
    end
  end
  
  function gameCallbackEvent( id )
    print( "Button clicked " .. id )
    --[[if ( isSequencesTheSame(id)) then
      table.insert(userSequence, id)
      numSequence = numSequence + 1
      userScore = userScore + 1
      ledPannel:setScore(userScore)
      if #userSequence >= #randSequence then
        timer.performWithDelay(500, function()
            numSequence = 1
            game.isPlayer = false
            insertRandomNumberToRandomSequence()
            --timer.resume(activateTimer)
            cleanSequence(userSequence)
          end)
      end
    else
        timer.pause( activateTimer )
        
        ledPannel:setState("Reset")
        ledPannel:setState("Start")
        
        game.isPlayer = false
        for i = 1, #rects do
          rects[i]:cancel()
          rects[i]:blinkingRepeatedly()
        end
        Runtime:addEventListener("touch", resetGame)
    end]]
  end
  
  local function init()
    for i = 1, #set.rects do
      set.rects[i]:setCallback(gameCallbackEvent)
    end
  end

  init()

  return set
end

return simpleSequence