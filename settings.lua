-----------------------------------------------------------------------------------------
--
-- settings.lua in this file you can find implementation of the game settings
--
-----------------------------------------------------------------------------------------
local widget = require( "widget" )

settings =
{
  isSoundOn = true;
  isVibrationOn = true;
}

function settings.new( options )
  local set = {}
  
  set.options = options        or {}
  set.x       = options.x      or 0
  set.y       = options.y      or 0
  set.width   = options.width  or 50
  set.height  = options.height or 50
  set.margin  = options.margin or 10
  
  local function onSettingsSwitchPress( event )
    local switch = event.target
    set.soundCheckBox.isVisible = switch.isOn
    if set.vibrationCheckBox then
      set.vibrationCheckBox.isVisible = switch.isOn
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
    local settingsCheckboxSheet = graphics.newImageSheet("img/settingsSheet.png", sheetOptions)
    local optionsCheckBox =
    {
      left = 0,
      top = 0,
      style = "checkbox",
      id = "settingsCheckbox",
      width = set.width,
      height = set.height,
      onPress = onSettingsSwitchPress,
      sheet = settingsCheckboxSheet,
      frameOff = 1,
      frameOn = 2
    }
  
    set.settingsCheckbox = widget.newSwitch(optionsCheckBox)
    set.settingsCheckbox.x = set.x
    set.settingsCheckbox.y = set.y
  
    -- Create sound
    local soundCheckboxSheet = graphics.newImageSheet("img/soundSheet.png", sheetOptions)
    optionsCheckBox.id = "soundCheckbox"
    optionsCheckBox.onPress = onSoundSwitchPress
    optionsCheckBox.sheet = soundCheckboxSheet
    optionsCheckBox.initialSwitchState = settings.isSoundOn
  
    set.soundCheckBox = widget.newSwitch(optionsCheckBox)
    set.soundCheckBox.x = set.settingsCheckbox.x + set.settingsCheckbox.width + set.margin
    set.soundCheckBox.y = set.y
    set.soundCheckBox.isVisible = false
    
    -- Create vibration
    if system.getInfo("platform") == "android" then
      local vibrationCheckBoxSheet = graphics.newImageSheet("img/vibrationSheet.png", sheetOptions)
      optionsCheckBox.id = "vibrationCheckbox"
      optionsCheckBox.onPress = onVibrationSwitchPress
      optionsCheckBox.sheet = vibrationCheckBoxSheet
      optionsCheckBox.initialSwitchState = settings.isVibrationOn
      
      set.vibrationCheckBox = widget.newSwitch(optionsCheckBox)
      set.vibrationCheckBox.x = set.soundCheckBox.x + set.soundCheckBox.width + set.margin
      set.vibrationCheckBox.y = set.y
      set.vibrationCheckBox.isVisible = false
    end
  end

  create()
  
  return set
end

return settings