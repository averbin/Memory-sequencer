-----------------------------------------------------------------------------------------
--
-- switch.lua in this file you can find implementation of the switch button.
local colors = require("colors")

switch = {}

function switch.new( options )
  local opt                = options                   or {}
  local set                = opt.group                 or display.newGroup()
  local x                  = opt.x                     or 0
  local y                  = opt.y                     or 0
  local width              = opt.width                 or 50
  local height             = opt.height                or 50
  set.isOn                 = opt.initialSwitchState    or false
  local frameOff           = opt.frameOff              or ""
  local frameOn            = opt.frameOn               or ""
  local strokeWidth        = opt.strokeWidth           or 0
  local strokeColorOn      = opt.strokeColorOn         or (colors['strokeColorButtonOn'])
  local strokeColorOff      = opt.strokeColorOff       or (colors['strokeColorButtonOff'])

  local function setViews()
    set.viewOn.isVisible = set.isOn
    set.viewOff.isVisible = not set.isOn
  end
  
  local function viewOffTapped( event )
    set.isOn = true
    setViews()
  end
  
  local function viewOnTapped( event )
    set.isOn = false
    setViews()
  end

  local function create()
    local paint = 
    {
      type = "image",
      filename = frameOff
    }
    local viewOff = display.newRoundedRect( set, x, y, width, height, 4 )
    viewOff.strokeWidth = strokeWidth
    viewOff:setStrokeColor( unpack(strokeColorOff) )
    viewOff.fill = paint
    viewOff:addEventListener("tap", viewOffTapped)
    set.viewOff = viewOff

    paint.filename = frameOn
    local viewOn = display.newRoundedRect( set, x, y, width, height, 4 )
    viewOn.strokeWidth = strokeWidth
    viewOn:setStrokeColor( unpack(strokeColorOn) )
    viewOn.fill = paint
    viewOn:addEventListener("tap", viewOnTapped)
    set.viewOn = viewOn

    viewOn.isVisible = set.isOn
    viewOff.isVisible = not set.isOn

    set.xPos = x
    set.yPos = y
  end

  create()

  return set
end

return switch