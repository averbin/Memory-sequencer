composer = require("composer")
game = require("game")
screen = require( "screen" )
local grid = require( "grid" )

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local scene = composer.newScene()

local function gotoGameBoard()
  composer.removeScene("gameBoard")
  composer.gotoScene( "gameBoard", { time=800, effect="crossFade" } )
end

local function gotoPairs()
  game.type = "pairs"
  gotoGameBoard()
end

local function gotoFourth()
  --game.buttons = 4
  game.type = "four"
  gotoGameBoard()
end

local function gotoNineth()
  --game.buttons = 9
  game.type = "nine"
  gotoGameBoard()
end

local function gotoShapes()
  game.type = "shapes"
  gotoGameBoard()
end

function createMenuButtonFunc(group, name, x, y, width, height, shape, cornerRadius, cellColor, gameCallbackEvent)
  local button = display.newRoundedRect( x, y, width, height, cornerRadius)
  button:setFillColor(0.1, 0.1, 0.1, 1)
  button:setStrokeColor(0.8, 0.8, 1, 1)
  button.strokeWidth = 2
  group:insert( button )
  return button
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screen.width, screen.height)
    backgroundImage.x = screen.x
    backgroundImage.y = screen.y
  
  local rectWidth = 100
  local rectHeight = 100
  local margin = 10
  local screen = screen.new()
  local side = screen:convertPersentToPixels( 75 )
  print("side: " .. side)

  local gridOptions = 
  {
    group = sceneGroup,
    x = display.contentCenterX,
    y = display.contentCenterY,
    width = side,
    height = side,
    rows = 2,
    columns = 2, 
    sideMargin = 0,
    rowMargin = 15,
    columnMargin = 15,
    frameOn = false,
    cornerRadius = 4
  }

  local gameGrid = grid.new( gridOptions )
  gameGrid:create( createMenuButtonFunc )
  buttons = gameGrid:getButtons()
  
  local paints = {
    {
      filename = "img/fourth_board.png",
      gotoFunc = gotoFourth
    }, -- Fourth button
    {
      filename = "img/ninth_board.png",
      gotoFunc = gotoNineth
    }, -- Nineth button
    {
      filename = "",
      gotoFunc = gotoPairs
    }, -- Pairs button
    {
      filename = "img/shape_board.png",
      gotoFunc = gotoShapes
    } -- Shape button
  }

  for i = 1, #buttons do
    local button = buttons[i]
    local paint = { type = "image", filename = paints[i].filename }
    button.fill = paint
    button:addEventListener("tap", paints[i].gotoFunc)
  end

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