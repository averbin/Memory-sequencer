-----------------------------------------------------------------------------------------
--
-- ledState.lua in this file you can find implementation of Led state for showing
-- game state play or record or blinking state.
--
-----------------------------------------------------------------------------------------
local effects = require("effects")

local ledState = {}

function ledState.new( options )
  local set           = {}
  options             = options                or {}
  set.group           = options.group
  set.x               = options.x              or 0
  set.y               = options.y              or 0
  set.width           = options.width          or 140
  set.height          = options.height         or 128
  set.state           = options.state          or "" -- "Start" , "Play", "Record", "Reset"
  
  backgroundImgPath   = options.backgroundPath or "img/play_panel.png"
  playImgPath         = options.playPathImg    or "img/play_on.png"
  recordImgPath       = options.recodPathImg   or "img/Record_on.png"
  
  set.backgroundImg   = nil
  set.playImg         = nil
  set.recordImg       = nil
  set.isPlayRunning   = false
  set.isRecordRunning = false
  
  local function create()
    set.backgroundImg = display.newImageRect(set.group, backgroundImgPath,
      set.width, set.height)
    
    set.playImg = display.newImageRect(set.group, playImgPath,
      set.width, set.height)
    
    set.recordImg = display.newImageRect(set.group, recordImgPath,
      set.width, set.height)
  end
  
  function blink( obj )
    effects.simpleBlinking(obj)
  end
  
  function cancelAllEffects()
    if set.isPlayRunning == true then
      effects.cancel(set.playImg)
      set.isPlayRunning = false
    end
    if set.isRecordRunning == true then
      effects.cancel(set.recordImg)
      set.isRecordRunning = false
    end
  end
  
  function set:start()
    cancelAllEffects()

    blink(self.playImg)
    blink(self.recordImg)
    
    self.isPlayRunning = true
    self.isRecordRunning = true
  end
  
  function set:play()
    cancelAllEffects()
    blink(self.playImg)
    self.isPlayRunning = true
  end
  
  function set:record()
    cancelAllEffects()
    blink(self.recordImg)
    self.isRecordRunning = true
  end
  
  function set:setState( state )
    if state == "Start" then
      set:start()
    elseif state == "Play" then
      set:play()
    elseif state == "Record" then
      set:record()
    elseif state == "Reset" then
      cancelAllEffects()
    else
      assert("No state. or state empty! State is : " .. state)
    end
  end

  create()
  
  return set
end

return ledState