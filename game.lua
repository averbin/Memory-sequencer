-----------------------------------------------------------------------------------------
--
-- level.lua in this file you can find implementation of the game state and type.
-- This table should translate to game.lua

local simpleSequencer = require("simpleSequence")
local shapesSequencer = require("shapeSequence")
local pairsSequencer = require("pairsSequence")
local loadsave = require("loadsave")
local ledPannel = require("ledPannel")
local settings = require("settings")

game = 
{
  isPlayer = false,
  type = "", -- "four", "nine", "pairs", "shapes"

  rows = 0,
  columns = 0,
  store = 
  {   
    scores = 
    {
      [ "four" ]   = 0,
      [ "nine" ]   = 0,
      [ "pairs" ]  = 0,
      [ "shapes" ] = 0
    },
    isVibrationOn = false,
    isSoundOn = false, 
  },
}

function game.new(options)
  local set     = {}
  
  options       = options           or {}
  set.buttons   = options.buttons   or {}
  set.ledPannel = options.ledPannel or {}
  set.score     = 0
  set.sequencer = nil
  
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
    if set.ledPannel and score then
      set.ledPannel:setScore( score )
      set.ledPannel:setState("Start")
    end
  end
  
  function set:loadScore()
    local store = loadsave.loadTable( "settings.json" )
    if not store then
      return
    end
    
    game.store = store
    
    if game.store.scores and game.store.scores[game.type] then
      self.score = game.store.scores[game.type]
      if game.store.isVibration ~= nil and game.store.isSound ~= nil then
        settings.isVibrationOn = game.store.isVibration
        settings.isSoundOn = game.store.isSound
      end
    end
  end
  
  function set:saveScore()
    game.store.scores[game.type] = self.score
    game.store.isVibration = settings.isVibrationOn
    game.store.isSound = settings.isSoundOn
    loadsave.saveTable( game.store, "settings.json")
  end
  
  function set:init()
    setScoreToPannel(self.score)
    
    local options = 
    {
      buttons = self.buttons,
      ledPannel = self.ledPannel,
      endGameCallback = function() return self:handleEndGame() end,
      isPlayerTurnCallback = isPlayerTurn,
      setTurnCallback = setTurn,
      setScoreCallback = function( score ) return self:setScore( score ) end,
      getScoreCallback = function() return self:getScore() end,
      rows = game.rows,
      columns = game.columns
    }
    
    if game.type == "four" or game.type == "nine" then
      self.sequencer = simpleSequencer.new(options)
    elseif game.type == "shapes" then
      self.sequencer = shapesSequencer.new(options)
    else --pairs
      self.sequencer = pairsSequencer.new(options)
    end
  end
  
  function loop()
    set.ledPannel:setScore(set.score)
    set.sequencer:start()
    Runtime:removeEventListener( "touch", loop)
  end
  
  function set:startLoop()
    if set.sequencer then
      if self.score < 1 then
        loop()
      else
        Runtime:addEventListener( "touch", loop)
      end
    end
  end
  
  function set:stopLoop()
    self.sequencer:stop()
  end
  
  set:loadScore()

  return set
end

return game