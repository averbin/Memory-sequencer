-----------------------------------------------------------------------------------------
--
-- toolButton.lua in this file you can find implementation of button table.
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
  end
  
  createToolButton()
  return set
end

return tooButton