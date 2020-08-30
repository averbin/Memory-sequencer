composer = require("composer")
local gameState = require("gameState")

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local scene = composer.newScene()

local function gotoPairs()
  
end

local function gotoFourth()
  gameState.Type = {id = 4, type = "four"}
  composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoNineth()
  gameState.Type = {id = 9, type = "nine"}
  composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoFigures()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screenWidth, screenHeight)
    backgroundImage.x = centerX
    backgroundImage.y = centerY
  
  local rectWidth = 100
  local rectHeight = 100
  local margin = 10
  local forthButton = display.newImageRect(sceneGroup, "img/fourth_board.png",
    rectWidth, rectHeight)
  forthButton.x = (centerX - 50 - margin)
  forthButton.y = (centerY - 50 - margin)
  forthButton:addEventListener("tap", gotoFourth)
  
  local ninthButton = display.newImageRect(sceneGroup, "img/ninth_board.png",
    rectWidth, rectHeight)
  ninthButton.x = (centerX + 50 + margin)
  ninthButton.y = (centerY - 50 - margin)
  ninthButton:addEventListener("tap", gotoNineth)
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
      -- Code here runs when the scene is entirely on screen
    end
end

-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
      -- Code here runs immediately after the scene goes entirely off screen
    end
end

-- destroy()
function scene:destroy( event ) 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene