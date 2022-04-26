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

function screen.new()
  local set = {}
  set.width = display.actualContentWidth
  set.height = display.actualContentHeight
  set.centerX = screen.centerX
  set.centerY = screen.centerY

  function set:findSide()
    local side = 0
    if screen.height > screen.width then
      side = screen.width
    else
      side = screen.height
    end

    return side
  end

  function set:convertPersentToPixels( persent )
    return self.sideSize * ( persent / 100 )
  end

  set.sideSize = set:findSide()

  return set
end

return screen