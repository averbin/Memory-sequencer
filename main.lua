-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

composer = require("composer")
debugger = require("mobdebug.mobdebug")
debugger.start()

if( onIOS or onAndroid ) then
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar	
end

composer.gotoScene( "levelsMenu" ) -- menu