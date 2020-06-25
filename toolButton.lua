-----------------------------------------------------------------------------------------
--
-- toolButton.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )

tooButton = {}

function tooButton.new( options )
  options        = options                   or {}
  group          = options.group             or nil
  id             = options.name              or ""
  
  x              = options.x                 or 0
  y              = options.y                 or 0
  width          = options.width             or 10
  height         = options.height            or 10
  
  cornerRadius   = options.cornerRadius      or 0
  
  fillColor      = options.fillColor         or {}
  strokeColor    = options.strokeColor       or {}
  
  image          = options.image or ""
  isImageVisible = options.isImageVisible or false
  
  if not group then
    group = display.newGroup()
  end
  
  function group:Blink(obj)
    print("Id: " .. obj.id)
    transition.resume(obj.id)
  end
  
  function touch( event )
      group:Blink(event.target)
      return true
    end
  
  local function onObjectTap( event )
    group:Blink(event.target)
    return true
  end
  
  local function CreateToolButton()
    button = display.newRoundedRect(group, x, y, width, height, cornerRadius)
    button.id = id
    button:setFillColor(0.1, 0.1, 0.1, 1)
    button:setStrokeColor(unpack(strokeColor))
    button.strokeWidth = 2
    button:addEventListener("tap", touch)
    
    insideRect = display.newRoundedRect(group, x, y, width, height, cornerRadius)
    insideRect.id = id
    insideRect:setFillColor(unpack(fillColor))
    insideRect:setStrokeColor(unpack(strokeColor) )
    insideRect.strokeWidth = 2
    transition.blink(insideRect, { tag = id, time = 1500, onRepeat = function ( obj ) transition.pause(obj) end })
  end
  
  CreateToolButton()
  return group
end

return tooButton