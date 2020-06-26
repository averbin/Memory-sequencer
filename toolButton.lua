-----------------------------------------------------------------------------------------
--
-- toolButton.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )

tooButton = {}

function tooButton.new( options )
  set = {}
  setmetatable(set, {})
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
  
  if not set.group then
    set.group = display.newGroup()
  end
  
  function set.group:blink(id)
    print("Id: " .. id)
    transition.resume(id)
  end
  
  function touch( event )
    set:blink(event.target.id)
    return true
  end
  
  local function onObjectTap( event )
    set:blink(event.target)
    return true
  end
  
  local function CreateToolButton()
    set.group.id = set.id
    local button = display.newRoundedRect(set.group, set.x, set.y, set.width, set.height, set.cornerRadius)
    button.id = set.id
    button:setFillColor(0.1, 0.1, 0.1, 1)
    button:setStrokeColor(unpack(set.strokeColor))
    button.strokeWidth = 2
    --button:addEventListener("tap", touch)
    
    local insideRect = display.newRoundedRect(set.group, set.x, set.y, set.width, set.height, set.cornerRadius)
    insideRect.id = set.id
    insideRect:setFillColor(unpack(set.fillColor))
    insideRect:setStrokeColor(unpack(set.strokeColor) )
    insideRect.strokeWidth = 2
    transition.blink(insideRect, { tag = set.id, time = 1000, onRepeat = function ( obj ) transition.pause(obj) end })
  end
  
  CreateToolButton()
  return set
end

return tooButton