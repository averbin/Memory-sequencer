-----------------------------------------------------------------------------------------
--
-- level.lua in this file you can find implementation of the game state and type.
-- This table should translate to game.lua

local sequencer = require( "simpleSequence" ) 
local loadsave = require( "loadsave" )

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
  set.rectungles = options.rectungles or {}
  set.score = 0
  
  function set:loadScore()
    game.scores = loadsave.loadTable( "settings.json" )
    if game.scores and game.scores[game.type] then
      self.score = game.scores[game.type]
    end
  end
  
  function set:getScore()
    return self.score
  end

  function set:saveScore()
    game.scores[game.type] = self.score
    loadsave.saveTable( game.scores, "settings.json")
  end

  function set:startLoop()
    
  end
  
  return set
end

return game