composer = require("composer")
game = require("game")
screen = require( "screen" )
local grid = require( "grid" )

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
  local buttonMenuGroup = display.newGroup()
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screen.width, screen.height)
  backgroundImage.x = screen.centerX
  backgroundImage.y = screen.centerY

  local x = screen.x
  local y = screen.y
  local screen = screen.new()
  local side = screen:convertPersentToPixels( 70 )

  local gridOptions = 
  {
    group = buttonMenuGroup,
    x = screen.centerX,
    y = screen.centerY,
    width = side,
    height = side,
    rows = 2,
    columns = 2, 
    sideMargin = 0,
    rowMargin = 20,
    columnMargin = 20,
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

  buttonMenuGroup.y = 30
  
  local creatorText = display.newText(sceneGroup, "Made by Alexander Verbin",
      screen.centerX,
      screen.height - 15, native.systemFont, 12)
  sceneGroup:insert(buttonMenuGroup)
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