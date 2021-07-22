-----------------------------------------------------------------------------------------
--
-- blinkButton.lua in this file you can find implementation of button table.
--
-----------------------------------------------------------------------------------------
local effects = require( "effects" )
local game = require( "game" )
local widget = require( "widget" )

blinkButton = {}

function blinkButton.new( options )
  local set          = {}
  options            = options                   or {}
  set.group          = options.group             or nil
  set.id             = options.name              or ""

  set.x              = options.x                 or 0
  set.y              = options.y                 or 0
  set.width          = options.width             or 10
  set.height         = options.height            or 10

  set.cornerRadius   = options.cornerRadius      or 0

  set.fillColor      = options.fillColor         or {}
  set.strokeColor    = options.strokeColor       or {}

  set.image          = options.image or ""
  set.isImageVisible = options.isImageVisible or false
  gameCallbackEvent  = options.gameCallbackEvent or nil
  
  local function handleButtonEvent( target )
    if game.isPlayer then
      if gameCallbackEvent then
        gameCallbackEvent(set)
      end
      
      if game.type == 'shapes' then
        if set.insideRect.alpha <= 0.1 then 
          set:switchOn()
        else
          set:switchOff()
        end
      end
    end
  end
  
  if not set.group then
    set.group = display.newGroup()
  end

  local function createToolButton()
    set.group.id = set.id
    local button = display.newRoundedRect(set.group, set.x, set.y, set.width, set.height, set.cornerRadius)
    button.id = set.id
    button:setFillColor(0.1, 0.1, 0.1, 1)
    button:setStrokeColor(unpack(set.strokeColor))
    button.strokeWidth = 2
    --button.isVisible = false
    
    local insideRect = display.newRoundedRect(set.group, set.x, set.y, set.width, set.height, set.cornerRadius)
    insideRect.id = set.id
    insideRect:setFillColor(unpack(set.fillColor))
    insideRect:setStrokeColor(unpack(set.strokeColor) )
    insideRect.strokeWidth = 2
    insideRect.alpha = 0.1
    --insideRect.isVisible = false
    set.insideRect = insideRect
    set.insideRect.alpha = 0.1
    set.insideRect:addEventListener("tap", handleButtonEvent)
    set.isTurnOn = false
  end
  
  function set:blink()
    effects.blink(self.insideRect)
  end
  
  function set:blinkingRepeatedly()
    effects.simpleBlinking(self.insideRect)
  end
  
  function set:sequenceBlinking()
    effects.sequenceBlinking(self.insideRect)
  end
  
  function set:cancel()
    effects.cancel(self.insideRect)
  end
  
  function set:vibrate()
    effects.vibrate()
  end
  
  function set:setCallback( callback )
    gameCallbackEvent = callback
  end
  
  function set:switchOn()
    self.isTurnOn = true
    self.insideRect.alpha = 1.0
    --[[
    transition.to(self.insideRect, 
      { 
        time = 100,
        iterations = 9,
        onStart = function()self.insideRect.alpha = 0.1  print("onStart: alpha : " .. self.insideRect.alpha) end,
        onRepeat = function() self.insideRect.alpha = self.insideRect.alpha + 0.1 end,
        onComplete = function() 
          self.insideRect.alpha = 1.0 print("onComplete: alpha : " .. self.insideRect.alpha) 
        end
      }
    )
    ]]
  end
  
  function set:switchOff()
    if self.isTurnOn == false then
      print("switchOff id : " .. self.id)
    end 
    self.isTurnOn = false
    self.insideRect.alpha = 0.1
    --[[
    transition.to(self.insideRect, 
      { 
        time = 100,
        iterations = 9,
        onStart = function() self.insideRect.alpha = 1.0 print("onStart: alpha : " .. self.insideRect.alpha) end,
        onRepeat = function() self.insideRect.alpha = self.insideRect.alpha - 0.1 print("onRepeat: alpha : " .. self.insideRect.alpha) end,
        onComplete = function() 
          self.insideRect.alpha = 0.1 print("onComplete: alpha : " .. self.insideRect.alpha) 
        end
      }
    )
    ]]
  end

  createToolButton()
  return set
end

return blinkButton