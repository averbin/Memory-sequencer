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
  set.numSequence      = 0
  set.randSequence     = {}
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
    elseif element == 0 then
      return false
    end
    return true
  end
  
  function set:insertRandomShape()
    local direction = 0
    local lastElement = 0
    if #self.randSequence == 0 then
      local var = math.random(#self.buttons)
      table.insert(self.randSequence, var)
    else
      while true do
        lastElement = math.random(#self.buttons)
        if isDirectionCorrect(self.randSequence, self.columns, self.rows, lastElement) then
          break
        end
      end

      table.insert(self.randSequence, lastElement)
    end
    print(self.randSequence)
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
    print("--== Hide buttons ==--")

    for i = 1, #set.randSequence do 
      print("hide button: " .. set.randSequence[i])
      set.buttons[set.randSequence[i]]:switchOff()
    end
    set.ledPannel:setState("Record")
    setTurnCallback( true )
  end
  
  function showSequence()
    if isPlayerTurnCallback() == false then
      transition.to(set, 
        {
          time = 1000,
          onStart = showButtons,
          onComplete = hideButtons,
          iterations = 1
        }
      )
    end
  end
  
  function set:setNexStep()
    cleanSequence( self.randSequence )
    cleanSequence( self.userSequence )
    
    for i = 1, self.numSequence do
      self:insertRandomShape()
    end
  end
  
  function set:nextStep()
    transition.to( {}, { time = 1000, onComplete = function() showSequence() end })
  end
  
  function set:resetGame()
    self:cleanGame()
    self:insertRandomShape()
    
    if self.activateTimer then
      timer.resume(set.activateTimer)
    else
      self.activateTimer = timer.performWithDelay( 1000, showSequence, 0)
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
  
  function set:finish()
    print("Call function finish")
    setTurnCallback( false )
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

  local function gameCallbackEvent( button )
    if set:findInRandomSequence(button) then
      table.insert(set.userSequence, button)
      button:vibrate()
      if #set.userSequence == #set.randSequence then
        setTurnCallback( false )
        set.numSequence = #set.randSequence + 1
        set.userScore = set.userScore + 1
        set.ledPannel:setScore(set.userScore)
        transition.to({}, { delay = 500, 
          onComplete = function()
              for i = 1, #set.randSequence do 
                set.buttons[set.randSequence[i]]:switchOff()
              end
              set:setNexStep()
              set:nextStep()
            end })
        print("finished loop")
      end
    else
      -- TODO : finish the game
      set:finish()
    end
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