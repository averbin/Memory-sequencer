-----------------------------------------------------------------------------------------
--
-- toolButton.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )

tooButton = {}

function tooButton.new( options )
  options = options or {}
  group = options.group
  id = options.name or ""
  x = options.x or 0
  y = options.y or 0
  width = options.width or 10
  height = options.height or 10
  cornerRadius = options.cornerRadius or 0
  image = options.image or ""
  isImageVisible = options.isImageVisible or false
  
  if not group then
    group = display.newGroup()
  end
  
  function group:Blink()
    transition.resume(id)
  end
  
  local function onObjectTap( event )
    group:Blink()
    return true
  end
  
  local function CreateToolButton()
    local button = display.newRoundedRect(group, x, y, width, height, cornerRadius)
    button:setFillColor( 0.0, 0.0, 0.0, 1)
    button:setStrokeColor(0.8, 0.8, 1, 1)
    button.strokeWidth = 2
    local insideRect = display.newRoundedRect(group, x, y, width, height, cornerRadius)
    insideRect:setFillColor( 1, 1, 1, 1)
    insideRect:setStrokeColor( 0.8, 0.8, 1, 1 )
    insideRect.strokeWidth = 2
    transition.blink(insideRect, { tag = id, time = 1500, onRepeat = function ( event ) transition.pause() end })
    button:addEventListener("tap", onObjectTap)
  end
  
  CreateToolButton()
  return group
end

return tooButton