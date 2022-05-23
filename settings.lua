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
    local sheetOptions =
    {
      width = 512,
      height = 512,
      numFrames = 2,
      sheetContentWidth = 1024,
      sheetContentHeight = 512
    }
    -- Create settings buttons
    local opt = {group = group, x = x, y = y + 1, width = width, height = height, initialSwitchState = false, frameOff = "img/settings1.png", frameOn = "img/settings_on1.png", strokeWidth = 2, strokeColor = (colors['strokeColorButton'])}
    local settingsCheckbox = switch.new( opt )
    settingsCheckbox:addEventListener("tap", onSettingsSwitchPress)

    -- Create sound
    local soundCheckboxSheet = graphics.newImageSheet("img/soundSheet.png", sheetOptions)
    local optionsCheckBox =
    {
      left = 0,
      top = 0,
      style = "checkbox",
      id = "settingsCheckbox",
      width = width,
      height = height,
      onPress = onSettingsSwitchPress,
      sheet = soundCheckboxSheet,
      frameOff = 1,
      frameOn = 2
    }
    optionsCheckBox.id = "soundCheckbox"
    optionsCheckBox.onPress = onSoundSwitchPress
    optionsCheckBox.sheet = soundCheckboxSheet
    optionsCheckBox.initialSwitchState = settings.isSoundOn
  
    soundCheckBox = widget.newSwitch(optionsCheckBox)
    soundCheckBox.x = settingsCheckbox.x + settingsCheckbox.width + margin
    soundCheckBox.y = y
    soundCheckBox.isVisible = false
    group:insert( soundCheckBox )
    
    -- Create vibration
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
  end

  create()
  
  return group
end

return settings