-----------------------------------------------------------------------------------------
--
-- pairsSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

local clock = os.clock
math.randomseed( os.time() )

local pairsSequence = {}

function pairsSequence.new( options )
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
  
  local function init()
    --[[for i = 1, #set.buttons do
      set.buttons[i]:setCallback(gameCallbackEvent)
    end]]
  end
  
  function set:start()
    --self:resetGame()
  end
  
  function set:stop()
    --self:cleanGame()

    --[[if self.activatedTimer and self.activatedTimer._expired == false then
      timer.cancel(self.activateTimer)
    end]]
  end
  
  init()
  
  return set
end

return pairsSequence