local composer = require("composer")
local game = require("game")
local screen = require("screen")
local grid = require("grid")
local colors = require("colors")

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
  button:setStrokeColor(unpack(colors['strokeColorButton']))
  button.strokeWidth = 2
  group:insert( button )
  return button
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  display.setDefault( "magTextureFilter", "nearest" )
  local sceneGroup = self.view
  local buttonMenuGroup = display.newGroup()
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screen.width, screen.height)
  backgroundImage.x = screen.centerX
  backgroundImage.y = screen.centerY

  local titleSide = screen:devideHeightByPieces( 3 )

  local title = display.newImageRect(sceneGroup, "img/title.png", titleSide, screen.height * 0.2)
  title.x = screen.centerX
  title.y = ( screen.height * 0.1) + display.topStatusBarContentHeight

  local creatorText = display.newText(sceneGroup, "Made by Alexander Verbin",
      screen.centerX,
      screen.centerY, native.systemFont )
  creatorText.y = screen.bottomSafetyArea
  creatorText:setFillColor( unpack(colors['strokeColorButton']) )
  sceneGroup:insert(buttonMenuGroup)

  local gameSide = screen:convertPersentToPixels(90)
  local gridOptions = 
  {
    group = buttonMenuGroup,
    x = screen.centerX,
    y = screen.centerY,
    width = gameSide,
    height = gameSide,
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
      filename = "img/pair_board.png",
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