-----------------------------------------------------------------------------------------
--
-- shapeSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

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
  set.randSequence     = {7,12,17}
  set.userSequence     = {}
  set.activateTimer    = nil
  
  function isExistsElement ( array, element )
    for i = 1, #array do
      if array[i] == element then
        return true
      end
    end
    return false
  end
  
  function isDirectionCorrect ( array, columns, rows, element )
    local x = element % columns
    if element > columns * rows then
      return false
    elseif element < 0 then
      return false
    elseif x > rows then
      return false
    elseif isExistsElement( array, element) then
      return false
    end
    return true
  end
  
  function set:insertRandomShape()
    local direction = 0
    local lastElement = 0
    if #self.randSequence == 0 then
      local var = math.random(#self.buttons)
      print("var: " .. var)
      table.insert(self.randSequence, var)
    else
      while true do
        local direction = math.random(1, 4) -- 1 left, 2 top, 3 right, 4 down
        lastElement = self.randSequence[#self.randSequence]
        if direction == 1 then -- left
          print("Move left")
          lastElement = lastElement - 1
        elseif direction == 2 then -- top
          print("Move top")
          lastElement = lastElement - self.rows
        elseif direction == 3 then -- right
          print("Move right")
          lastElement = lastElement + 1
        elseif direction == 4 then -- down
          print("Move down")
          lastElement = lastElement + self.rows
        else
          assert("error: wrong direction!")
        end
        if isDirectionCorrect(self.randSequence, self.columns, self.rows, lastElement) then
          break
        end
      end

      table.insert(self.randSequence, lastElement)
    end
  end
  
  local function cleanSequence( sequence )
    for i=1, #sequence do sequence[i] = nil end
  end
  
  function set:cleanGame()
    --cleanSequence(self.randSequence)
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
    setTurnCallback( true )
  end
  
  function showSequence( event )
    if isPlayerTurnCallback() == false then
      transition.to(set, 
        {
          time = 1000,
          onStart = showButtons,
          onComplete = hideButtons
        }
      )
    end
  end
  
  function set:resetGame()
    set:cleanGame()
    set:insertRandomShape()
    
    if set.activateTimer then
      timer.resume(set.activateTimer)
    else
      set.activateTimer = timer.performWithDelay( 1000, showSequence, 0)
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
  
  function set:finish()
  
  end

  local function gameCallbackEvent( id )
    print("button id is: " .. id)
  end

  function set:init()
    for i = 1, #set.buttons do
      set.buttons[i]:setCallback(gameCallbackEvent)
    end
  end
  
  set:init()
  
  return set
end

return shapeSequence