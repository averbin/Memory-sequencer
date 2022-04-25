-----------------------------------------------------------------------------------------
--
-- grid.lua Grid table with all function for calculation.
--
-----------------------------------------------------------------------------------------
local colors = require("colors")
local blinkButton = require("blinkButton")

--[[ Example:
options = 
{
  group 
  x = centerX - width / 2,
  y = centerY - height / 2,
  width = 300,
  height = 300,
  rows = 2,
  columns = 2, 
  sideMargin = 5,
  rowMargin = 50,
  columnMargin = 50,
  anchorX = 0,
  anchorY = 0,
  frameOn = true
} 
]]

grid = {}

function grid.new(options)
  
  options                 = options               or {}
  local group             = options.group         or nil
  local x                 = options.x             or 0
  local y                 = options.y             or 0
  local width             = options.width         or 500
  local height            = options.height        or 500
  local rows              = options.rows          or 3
  local columns           = options.columns       or 3
  local sideMargin        = options.sideMargin    or 25
  local rowMargin         = options.rowMargin     or 10
  local columnMargin      = options.columnMargin  or 10
  
  local anchorX           = options.anchorX       or 0.5
  local anchorY           = options.anchorY       or 0.5
  local frameOn           = options.frameOn
  local cornerRadius      = options.cornerRadius  or 5
  local gameCallbackEvent = options.gameCallbackEvent
  local typeOfGame        = options.typeOfGame    or "four" 

  local buttons           = {}
  
  if not group then 
    group = display.newGroup()
  end

  local frame = display.newRect(group, x, y, width, height)
  frame.anchorX = anchorX
  frame.anchorY = anchorY
  frame:setFillColor(0.9, 0.1, 0.2)
  frame.isVisible = frameOn
  group.frame = frame
  group.buttons = buttons
  
  -- @param size - General width / height
  -- @param count - columns / rows count
  -- @param sideMargin - distance between general rect and element
  -- @param elementsMargin - distance between elements
  function calculateRectangleSide(size, count, sideMargin, elementsMargin)
    -- size without margin and size between elements
    local generalSize = size - sideMargin - ((count - 1) * elementsMargin) - sideMargin
    local rectSide = generalSize / count
    return rectSide
  end

  --~ @param Calculate next position of element base on x or y + side size + side margin
  function nextPosition(pos, sideSize, sideMargin)
    local result = pos + sideSize + sideMargin
    return result
  end
  
  --~ @param calculate actual postion of element using anchor and side Marging
  function postionUsingAnchor(pos, side, anchor, sideRect, sideMargin)
    return pos - (side * anchor) + (sideRect * anchor) + sideMargin 
  end

  function shuffle(tbl)
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end
  
  -- @Create grid
  function group:create( createButtonFunc )
    local rectWidth = calculateRectangleSide(width, columns, sideMargin, columnMargin) -- columnSide
    local rectHeight = calculateRectangleSide(height, rows, sideMargin, rowMargin) -- rowSide

    local yPos = postionUsingAnchor(y, height, anchorY, rectHeight, sideMargin)
    for i = 1, rows do
      local xPos = postionUsingAnchor(x, width, anchorX, rectWidth, sideMargin)
      -- Set position for columns.
      for j = 1, columns do
        local button = createButtonFunc(group, tostring((#buttons + 1)),
        xPos, yPos, rectWidth, rectHeight, "roundedRect",
        cornerRadius, {}, gameCallbackEvent)
        
        --button:switchOn()
        button.anchorX = anchorX
        button.anchorY = anchorY
        xPos = nextPosition(button.x, rectWidth, columnMargin)
        yPos = button.y
        table.insert(buttons, button)
      end
      yPos = nextPosition(yPos, rectHeight, rowMargin)
    end
  end
  
  function group:getButtons()
    return buttons
  end
  
  return group
end

return grid