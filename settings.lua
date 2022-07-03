-----------------------------------------------------------------------------------------
--
-- settings.lua in this file you can find implementation of the game settings
--
-----------------------------------------------------------------------------------------
local widget = require("widget")
local screen = require("screen")
local switch = require("switch")

settings =
{
  isSoundOn = true;
  isVibrationOn = true;
}

function settings.new( options )
  local group = display.newGroup()
  
  options = options        or {}
  x       = options.x      or 0
  y       = options.y      or 0
  width   = options.width  or 50
  height  = options.height or 50
  margin  = options.margin or 10
  
  local function onSettingsSwitchPress( event )
    local switch = event.target
    soundCheckBox.isVisible = switch.isOn
    if vibrationCheckBox then
      vibrationCheckBox.isVisible = switch.isOn
    end
  end

  local function onSoundSwitchPress( event )
    local switch = event.target
    settings.isSoundOn = switch.isOn
  end

  local function onVibrationSwitchPress( event )
    local switch = event.target
    settings.isVibrationOn = switch.isOn
    if switch.isOn then
      system.vibrate()
    end
  end
  
  local function create()
    -- Create settings buttons
    local optionsCheckBox = 
    {
      group = group,
      x = x,
      y = y,
      width = width,
      height = height,
      initialSwitchState = false,
      frameOff = "img/settings.png",
      frameOn = "img/settings_on.png",
      strokeWidth = 2,
      strokeColor = (colors['strokeColorButton'])
    }
    local settingsCheckbox = switch.new( optionsCheckBox )
    settingsCheckbox:addEventListener("tap", onSettingsSwitchPress)

    -- Create sound
    optionsCheckBox.frameOff = "img/sound_off.png"
    optionsCheckBox.frameOn = "img/sound_on.png" 
    optionsCheckBox.x = settingsCheckbox.x + settingsCheckbox.width + margin
    local soundCheckBox = switch.new( optionsCheckBox )
    soundCheckBox:addEventListener("tap", onSoundSwitchPress)
    --soundCheckBox.isVisible = false
    -- Create vibration
    --[[
    if system.getInfo("platform") == "android" then
      local vibrationCheckBoxSheet = graphics.newImageSheet("img/vibrationSheet.png", sheetOptions)
      optionsCheckBox.id = "vibrationCheckbox"
      optionsCheckBox.onPress = onVibrationSwitchPress
      optionsCheckBox.sheet = vibrationCheckBoxSheet
      optionsCheckBox.initialSwitchState = settings.isVibrationOn
      
      vibrationCheckBox = widget.newSwitch(optionsCheckBox)
      vibrationCheckBox.x = soundCheckBox.x + soundCheckBox.width + margin
      vibrationCheckBox.y = y
      vibrationCheckBox.isVisible = false
      
      group:insert( vibrationCheckBox )
    end
    ]]
  end

  create()
  
  return group
end

return settings