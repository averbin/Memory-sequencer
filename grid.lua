-- Grid table with all function for calculation.

-- Define module

--[[ Example:
options = 
{
  group 
  x = centerX - 300 / 2,
  y = centerY - 300 / 2,
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
  
  options = options or {}
  group = options.group or nil
  x = options.x or 0
  y = options.y or 0
  width = options.width or 500
  height = options.height or 500
  rows = options.rows or 3
  columns = options.columns or 3
  sideMargin = options.sideMargin or 25
  rowMargin = options.rowMargin or 10
  columnMargin = options.columnMargin or 10
  
  anchorX = options.anchorX or 0
  anchorY = options.anchorY or 0
  frameOn = options.frameOn

  elements = {}
  
  if not group then 
    group = display.newGroup()
  end
  gridField = display.newRect(group, x, y, width, height)
  gridField.anchorX = anchorX
  gridField.anchorY = anchorY
  gridField:setFillColor(0.9, 0.1, 0.2)
  gridField.isVisible = frameOn
  group.gridField = gridField
  group.elements = elements
  
  -- @param size - General width / height
  -- @param count - columns / rows count
  -- @param sideMargin - distance between general rect and element
  -- @param elementsMargin - distance between elements
  function group:calculateRectangleSide(size, count, sideMargin, elementsMargin)
    print("Size: " .. size)
    print("count: " .. count)
    print("side margin: " .. sideMargin)
    print("Distance between elements: " .. elementsMargin)
    -- size without margin and size between elements
    local generalSize = size - sideMargin - ((count - 1) * elementsMargin) - sideMargin
    local rectWidth = generalSize / count
    print("((size - sideMargin - ((count - 1) * elementsMargin) - sideMargin) / count) Rect width: " .. rectWidth)
    return rectWidth
  end

  --~ @param Calculate next position of element base on x or y + side size + side margin
  function group:nextPosition(pos, sideSize, sideMargin)
    local result = pos + sideSize + sideMargin
    print("NextPosition: pos + sideSize + sideMargin = " .. result)
    return result
  end
  
  -- @Create grid
  function group:create()
    local columnSide = group:calculateRectangleSide(width, columns, sideMargin, columnMargin)
    local rowSide = group:calculateRectangleSide(height, rows, sideMargin, rowMargin)
    
    if rows > 0 and columns > 0 then
      local yPos = y + sideMargin
      for i = 1, rows do
        local xPos = x + sideMargin
        -- Set position for columns.
        for j = 1, columns do
          local element = display.newRect(
            group,
            xPos,
            yPos,
            columnSide,
            rowSide)
          element.anchorX = anchorX
          element.anchorY = anchorY
          --[[ special effect 
          element.fill.effect = "generator.radialGradient"
 
          element.fill.effect.color1 = { 0.6, 0, 0.2, 1 }
          element.fill.effect.color2 = { 0.2, 0.2, 0.2, 1 }
          element.fill.effect.center_and_radiuses  =  { 0.5, 0.5, 0.5, 0.75 }
          element.fill.effect.aspectRatio  = 1
          ]]
          xPos = group:nextPosition(element.x, columnSide, columnMargin)
          yPos = element.y
          table.insert(elements, element)
        end
      yPos = group:nextPosition(yPos, rowSide, rowMargin)
      end
    end
  end
  
  return group
end

return grid