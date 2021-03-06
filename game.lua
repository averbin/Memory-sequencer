-----------------------------------------------------------------------------------------
--
-- level.lua in this file you can find implementation of the game state and type.
-- This table should translate to game.lua

local sequencer = require( "simpleSequence" ) 
local loadsave = require( "loadsave" )
local ledPannel = require( "ledPannel" )

game = 
{
  isPlayer = false,
  type = "", -- "four", "nine", "pairs", "shapes"
  scores = 
  {
    [ "four" ]   = 0,
    [ "nine" ]   = 0,
    [ "pairs" ]  = 0,
    [ "shapes" ] = 0
  }
}

function game.new(options)
  local set = {}
  options = options or {}
  set.buttons = options.buttons or {}
  set.ledPannel = options.ledPannel or {}
  set.score = 0
  set.sequencer = {}
  
  function set:handleEndGame()
    self:saveScore()
    self:startLoop()
  end
  
  function isPlayerTurn()
    if game.isPlayer == nil then
      game.isPlayer = false
    end
    return game.isPlayer
  end
  
  function setTurn( turn )
    game.isPlayer = turn
  end
  
  function set:setScore( score )
    self.score = score
  end
  
  function set:getScore()
    return self.score
  end
  
  -- Loading score from previous session.
  local function setScoreToPannel( score )
    set.ledPannel:setScore(score)
    set.ledPannel:setState("Start")
  end
  
  function set:loadScore()
    game.scores = loadsave.loadTable( "settings.json" )
    if game.scores and game.scores[game.type] then
      self.score = game.scores[game.type]
    end
  end
  
  function set:saveScore()
    game.scores[game.type] = self.score
    loadsave.saveTable( game.scores, "settings.json")
  end
  
  function set:init()
    self:loadScore() 
    setScoreToPannel(self.score)
    
    if game.type == "four" or game.type == "nine" then
      options = 
      {
        buttons = self.buttons,
        ledPannel = self.ledPannel,
        handleEndGame = function() return self:handleEndGame() end,
        isPlayerTurn = isPlayerTurn,
        setTurn = setTurn,
        setScore = function( score ) return self:setScore( score ) end,
        getScore = function() return self:getScore() end
      }
      self.sequencer = sequencer.new(options)
    end
  end
  
  function loop()
    set.ledPannel:setScore(set.score)
    set.sequencer:start()
    Runtime:removeEventListener( "touch", loop)
  end
  
  function set:startLoop()
    if self.score < 1 then
      loop()
    else
      Runtime:addEventListener( "touch", loop)
    end
  end
  
  function set:stopLoop()
    self.sequencer:stop()
  end

  return set
end

return game