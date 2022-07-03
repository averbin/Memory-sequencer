-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

composer = require("composer")
debugger = require("mobdebug.mobdebug")
native = require("native")
debugger.start()

native.setProperty("androidSystemUiVisibility", "immersiveSticky")

if( onIOS or onAndroid ) then
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar	
end

composer.gotoScene( "menu" ) -- menu