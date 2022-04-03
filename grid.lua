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

function createButton(group, name, x, y, width, height, shape, cornerRadius, cellColor, gameCallbackEvent)
  local newButton = blinkButton.new(
    {
      name = name,
      x = x,
      y = y,
      width = width,
      height = height,
      cornerRadius = cornerRadius,
      fillColor = cellColor or { 1,	1, 1, 1 },
      strokeColor = { 0.8, 0.8, 1, 1 },
      gameCallbackEvent = gameCallbackEvent
    }
  )
  group:insert(newButton.group)
  return newButton 
end

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
  
  gridField = display.newRect(group, x, y, width, height)
  gridField.anchorX = anchorX
  gridField.anchorY = anchorY
  gridField:setFillColor(0.9, 0.1, 0.2)
  gridField.isVisible = frameOn
  group.gridField = gridField
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
  
  function group:createShapeButton()
    return d8gitToArithmetic(colors[typeOfGame][1])
  end
  
  function shuffle(tbl)
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end
  
  function group:createPair()
    local rectWidth = calculateRectangleSide(width, columns, sideMargin, columnMargin) -- columnSide
    local rectHeight = calculateRectangleSide(height, rows, sideMargin, rowMargin) -- rowSide
    
    local count = 1
    local pairButtons = {}
    local nextColor = 1
    local colorCount = 1
    for i = 1, rows do
      for j = 1, columns do
        if ( nextColor % 2 ) == 0 then
          nextColor = nextColor + 1
          count = count + 1
        end
        color = d8gitToArithmetic(colors[typeOfGame][nextColor])
        local button = createButton(group, tostring(count), 
        0, 0, rectWidth, rectHeight, "roundedRect",
        cornerRadius, color, gameCallbackEvent)
        
        table.insert(pairButtons, button)
      end 
    end 
    
    pairButtons = shuffle(pairButtons)
    
    local yPos = postionUsingAnchor(y, height, anchorY, rectHeight, sideMargin)
    local xPos = postionUsingAnchor(x, width, anchorX, rectWidth, sideMargin)
    for i = 1, #pairButtons do
      local button = pairButtons[i]
      button:switchOn()
      button.anchorX = anchorX
      button.anchorY = anchorY
      print("button x: " .. button.x .. " y:" .. button.y)
      button.x = xPos
      button.y = yPos
      print("button x: " .. button.x .. " y:" .. button.y)
      xPos = nextPosition(button.x, rectWidth, columnMargin)
      yPos = button.y
      table.insert(buttons, button)
      --count = count + 1
      yPos = nextPosition(yPos, rectHeight, rowMargin)
    end
  end
  
  -- @Create grid
  function group:create()
    local rectWidth = calculateRectangleSide(width, columns, sideMargin, columnMargin) -- columnSide
    local rectHeight = calculateRectangleSide(height, rows, sideMargin, rowMargin) -- rowSide
    
    if typeOfGame == "pairs" then
      self:createPair()
      for i = 1, #buttons do
        print("Button id: " .. buttons[i].id .. " x: " .. buttons[i].x .. " y: " .. buttons[i].y )
        --print(buttons)
      end
      return
    end
    
    local yPos = postionUsingAnchor(y, height, anchorY, rectHeight, sideMargin)
    local count = 1
    for i = 1, rows do
      local xPos = postionUsingAnchor(x, width, anchorX, rectWidth, sideMargin)
      -- Set position for columns.
      for j = 1, columns do
        local color = {}
        if typeOfGame == "shapes" then
          color = self:createShapeButton()
        elseif typeOfGame == "pairs" then
          color = d8gitToArithmetic(colors[typeOfGame][count])
          if ( count % 4 ) == 0 then
            count = 0
          end
        else
          color = d8gitToArithmetic(colors[typeOfGame][count])
        end
        
        local button = createButton(group, tostring(count), 
        xPos, yPos, rectWidth, rectHeight, "roundedRect",
        cornerRadius, color, gameCallbackEvent)
        
        --button:switchOn()
        button.anchorX = anchorX
        button.anchorY = anchorY
        xPos = nextPosition(button.x, rectWidth, columnMargin)
        yPos = button.y
        table.insert(buttons, button)
        count = count + 1
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