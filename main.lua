-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

composer = require("composer")

if( onIOS or onAndroid ) then
	display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar	
end

composer.gotoScene( "game" )