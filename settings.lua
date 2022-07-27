-----------------------------------------------------------------------------------------
--
-- settings.lua in this file you can find implementation of the game settings
--
-----------------------------------------------------------------------------------------
local widget = require("widget")
local screen = require("screen")
local switch = require("switch")
local utils = require("utils")

settings =
{
  isSoundOn = true;
  isVibrationOn = true;
}

function settings.new( options )
  local group = display.newGroup()
  
  local options                 = options             or {}
  local x                       = options.x           or 0
  local y                       = options.y           or 0
  local width                   = options.width       or 50
  local height                  = options.height      or 50
  local margin                  = options.margin      or 10
  local strokeWidth             = options.strokeWidth or 0
  local soundCheckBox           = {}
  local vibrationCheckBox       = {}
  
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
    local settingsOptions = 
    {
      x = x,
      y = y,
      width = width,
      height = height,
      initialSwitchState = false,
      frameOff = "img/settings.png",
      frameOn = "img/settings_on.png",
      strokeWidth = strokeWidth,
      strokeColor = (colors['strokeColorButton'])
    }
    local settingsCheckbox = switch.new( settingsOptions )
    settingsCheckbox:addEventListener("tap", onSettingsSwitchPress)

    -- Create sound
    local soundOptions = utils:shallowcopy( settingsOptions )
    soundOptions.frameOff = "img/sound_off.png"
    soundOptions.frameOn = "img/sound_on.png" 
    soundOptions.x = settingsCheckbox.xPos + settingsCheckbox.width + margin

    soundCheckBox = switch.new( soundOptions )
    soundCheckBox:addEventListener("tap", onSoundSwitchPress)
    soundCheckBox.isVisible = false
    -- Create vibration
    if system.getInfo("platform") == "android" then
      local vibrationOptions = utils:shallowcopy( soundOptions )
      vibrationOptions.frameOff = "img/vibra_off.png"
      vibrationOptions.frameOn = "img/vibra_on.png"

      vibrationCheckBox = switch.new( vibrationOptions )
      vibrationCheckBox.x = soundCheckBox.width + margin
      vibrationCheckBox.isVisible = false
      
      group:insert( vibrationCheckBox )
    end
    group:insert( settingsCheckbox )
    group:insert( soundCheckBox )
  end

  create()
  
  return group
end

return settings