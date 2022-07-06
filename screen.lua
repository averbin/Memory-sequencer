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
screen.bottomSafetyArea = screen.height - screen.topSafetyArea

function screen:findSide()
  local side = 0
  if screen.height > screen.width then
    side = screen.width
  else
    side = screen.height
  end

  return side
end

function screen:devideHeightByPieces( pieces )
  return screen.height / pieces
end

function screen:convertPersentToPixels( persent )
  return self:findSide() * ( persent / 100 )
end

function screen:update()
  print("actualContentWidth: " .. display.actualContentWidth)
  print("actualContentHeight: " .. display.actualContentHeight)
  print("contentCenterX: " .. display.contentCenterX)
  print("contentCenterY: " .. display.contentCenterY)
  print("topStatusBarContentHeight: " .. display.topStatusBarContentHeight)
  print("bottomSafetyArea: " .. screen.height - screen.topSafetyArea)
  self.width = display.actualContentWidth
  self.height = display.actualContentHeight
  self.centerX = display.contentCenterX
  self.centerY = display.contentCenterY
  self.topSafetyArea = display.topStatusBarContentHeight
  self.bottomSafetyArea = screen.height - screen.topSafetyArea
end

return screen