composer = require("composer")
level = require("level")

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local scene = composer.newScene()

local function gotoPairs()
  
end

local function gotoFourth()
  level.buttons = 4
  level.type = "four"
  composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoNineth()
  level.buttons = 9
  level.type = "nine"
  composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoShapes()
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
  
  local paint = 
  {
    type = "image",
    filename = "img/fourth_board.png"
  }

  local forthButton = display.newRoundedRect(sceneGroup, centerX - 50 - margin, centerY - 50 - margin, rectWidth, rectHeight, 4)
  forthButton:setFillColor(0.1, 0.1, 0.1, 1)
  forthButton:setStrokeColor(0.8, 0.8, 1, 1)
  forthButton.strokeWidth = 2
  forthButton.fill = paint
  forthButton:addEventListener("tap", gotoFourth)
  
  paint.filename = "img/ninth_board.png"
  local ninthButton = display.newRoundedRect(sceneGroup, centerX + 50 + margin, centerY - 50 - margin, rectWidth, rectHeight, 4)
  ninthButton:setFillColor(0.1, 0.1, 0.1, 1)
  ninthButton:setStrokeColor(0.8, 0.8, 1, 1)
  ninthButton.strokeWidth = 2
  ninthButton.fill = paint
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