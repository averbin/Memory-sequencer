-----------------------------------------------------------------------------------------
--
-- effects.lua in this file you can find all effects for game.
--
-----------------------------------------------------------------------------------------
local M = {}

function M.sequenceBlinking( obj, time )
  transition.to( obj,
    { 
      time = time or 250, 
      alpha = 1.0,
      iterations = 1,
      onComplete = function ( obj ) 
        transition.to( obj, 
          { alpha = 0.1, time = time or 250, iterations = 1})
      end
    }
    )
end

function M.blink( obj, time )
  obj.alpha = 1.0
  transition.blink(obj, {onRepeat = function( obj ) transition.cancel( obj ) obj.alpha = 0.1 end, time = time or 500 })
end

function M.blinkingRepeatedly( obj )
    transition.to( obj,
    { 
      time = 1000, 
      alpha = 1.0,
      iterations = 0,
      onComplete = function ( obj ) 
        transition.to( obj, { alpha = 0.1, time = 1000, iterations = 0})
      end
    }
  )
end

function M.cancel( obj )
    obj.alpha = 0.1
    transition.cancel( obj )
end

return M