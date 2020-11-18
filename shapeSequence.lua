-----------------------------------------------------------------------------------------
--
-- shapeSequence.lua in this file you can find implementation of the game state and type.
-- 
-----------------------------------------------------------------------------------------

local clock = os.clock
math.randomseed( os.time() )

local shapeSequence = {}

function shapeSequence.new( option )
  local set = {}
  
  set.option           = option                       or {}
  set.buttons          = option.buttons               or {}
  set.ledPannel        = option.ledPannel             or {}
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
  
  function set:start()
    
  end
  
  function set:stop()
    
  end
  
  function set:finish()
  
  end

  function set:init()
    
  end
  
  set:init()
  
  return set
end

return shapeSequence