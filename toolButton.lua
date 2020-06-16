-----------------------------------------------------------------------------------------
--
-- toolButton.lua
--
-----------------------------------------------------------------------------------------

local widget = require( "widget" )

local TooButton = {}

ToolButton.numCols = 1 -- number of columns
ToolButton.numRows = 1 -- number of rows
ToolButton.colSpace = 0 -- space between columns
ToolButton.rowsSpace = 0 -- space between rows
ToolButton.gridOffsetX = 0 -- space between elements on screen
ToolButton.gridOffsetY  = 0 -- space between elements on screen

local options = {
  group = rectGroup,
  x = 0,
  y = 0,
  width = width,
  height = height,
  cornerRadius = cornerRadius,
  fillColor = {1, 1, 1, 1},
  strokeColor = {0.8, 0.8, 1, 1}
  }

function CreateButton(name, x, y, width, height, shape, cornerRadius)
  local newButton = widget.newButton( 
    {
      id = name,
      shape = shape,
      cornerRadius = cornerRadius,
      width = width,
      height = height,
      fillColor = { default={0, 0, 0, 1}, over={1, 1, 1, 1} },
      strokeColor = { default={1, 1, 1, 1}, over={0.8, 0.8, 1, 1} },
      onEvent = handleButtonEvent,
      strokeWidth = 2
    }
  )
  newButton.x = x
  newButton.y = y
  return newButton 
end

function CreateRect( options )
  local newRect = display.newRoundedRect(
    options.group,
    options.x, options.y,
    options.width, options.height, options.cornerRadius )
  newRect.strokeWidth = 2
  newRect:setFillColor( 1 , 1, 1, 1)
  newRect:setStrokeColor( 0.8, 0.8, 1, 1 )
  newRect.isVisible = false
  return newRect
end

--function ToolButton.new(group, id, 
--    x, y,
--    width, height,
--    shape, cornerRadius,
--    fillColor, strokeColor)
--  set = {}
--  setmetatable(set, {element, mark})
--  return set
--end

return TooButton