-----------------------------------------------------------------------------------------
--
-- screen.lua in this file you can find all colors for each game type.
--
-----------------------------------------------------------------------------------------

local screen = {}

screen.width = display.actualContentWidth
screen.height = display.actualContentHeight
screen.centerX = display.contentCenterX
screen.centerY = display.contentCenterY
screen.topSafetyArea = display.topStatusBarContentHeight
screen.bottomSafetyArea = display.safeActualContentHeight
screen.originX = display.safeScreenOriginX
screen.originY = display.safeScreenOriginY
screen.safetyRect = {}
screen.centerSafeY = ( screen.topSafetyArea + screen.bottomSafetyArea ) / 2

function screen:isHeightMoreThanWidth()
  return screen.height > screen.width
end

function screen:findSide()
  local side = 0
  if self:isHeightMoreThanWidth() then
    side = screen.width
  else
    side = screen.height
  end

  return side
end

function screen:perToPixsHeight( persents )
  return self.height * persents / 100
end

function screen:perToPixsWidth( persents )
  return self.width * persents / 100
end

function calculateCenter()
  screen.centerSafeY = ( screen.originY + screen.bottomSafetyArea ) / 2
end

function screen:update()
  print("actualContentWidth: " .. display.actualContentWidth)
  print("actualContentHeight: " .. display.actualContentHeight)
  print("contentCenterX: " .. display.contentCenterX)
  print("contentCenterY: " .. display.contentCenterY)
  print("topStatusBarContentHeight: " .. display.topStatusBarContentHeight)
  print("bottomSafetyArea: " .. screen.height - screen.topSafetyArea)
  print("safeActualContentHeight :" .. display.safeActualContentHeight )
end

local function newLine( group , x1, y1, x2, y2)
  local line = display.newLine(group, x1, y1, x2, y2)
  line:setStrokeColor( 1, 0, 0, 1 )
  line.strokeWidth = 8
  return line
end

function screen:createSafetyArea()
  self.safetyRect = display.newGroup()

  local blueTopLine = newLine(self.safetyRect, display.safeScreenOriginX, display.safeScreenOriginY, display.safeActualContentWidth, display.safeScreenOriginY)
  blueTopLine:setStrokeColor( 0, 0, 1, 1)

  if safeArea == nil then
    safeArea = display.newRect(self.safetyRect,
      display.safeScreenOriginX,
      display.safeScreenOriginY,
      display.safeActualContentWidth,
      display.safeActualContentHeight
    )
    safeArea.x = display.contentCenterX
    safeArea.y = display.contentCenterY
    safeArea.alpha = 0.3
  end

end

function screen:findCenterBetweenPoints(x1, y1, x2, y2)
  return { x = ((x2 + x1) / 2), y = ((y2 + y1) / 2) }
end

function screen:findCenterBetweenObjects( obj1, obj2 )
  return self:findCenterBetweenPoints(obj1.x, obj1.y, obj2.x, obj2.y)
end

return screen