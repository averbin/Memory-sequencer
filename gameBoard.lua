-----------------------------------------------------------------------------------------
--
-- In this section we create game board with ui elements.
-- This table should translate to gameboard.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local grid = require( "grid" )
local ledPannel = require( "ledPannel" )
local game = require( "game" )
local settings = require( "settings" )

math.randomseed( os.time() )

local scene = composer.newScene()

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
game.isPlayer = false
local rectGroup = nil
local guiGroup = nil
local gameRectungles = {}

--local activateTimer = nil
local userScore = 0
local clock = os.clock

local backButton = nil
local settingsButton = nil


local function gotoMenu()
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=800, effect="crossFade" })
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Setting background image
function createBackground( sceneGroup )
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screenWidth, screenHeight)
  backgroundImage.x = centerX
  backgroundImage.y = centerY
end

function createGrid( sceneGroup )
  -- Rect group
  rectGroup = display.newGroup()
  
  if game.type == "four" then
    rows = 2
    columns = 2
  elseif game.type == "nine" then
    rows = 3
    columns = 3
  end

  options = 
  {
    group = rectGroup,
    x = centerX,
    y = centerY,
    width = 250,
    height = 250,
    rows = rows,
    columns = columns, 
    sideMargin = 0,
    rowMargin = 15,
    columnMargin = 15,
    frameOn = false,
    --gameCallbackEvent = gameCallbackEvent,
    typeOfGame = game.type
  } 
  
  gameGrid = grid.new(options)
  gameGrid:create()
  gameRectungles = gameGrid:getRects()
  -- Set elements to main sceneGroup
  sceneGroup:insert(rectGroup)
end

function createUI(sceneGroup)
  -- UI Group
  guiGroup = display.newGroup()
  
  -- Create led pannel
  options = 
  {
    group = guiGroup,
    x = centerX,
    y = 90,
    width = 70,
    height = 128,
    withFrame = true,
    cornerRadius = 5
  }

  ledPannel = ledPannel.new(options)
  ledPannel:setScore(userScore)
  ledPannel:setWidth( 420 )
  
  gameGrid.y = 30
  -- Create back button
  local paint = 
  {
    type = "image",
    filename = "img/back.png"
  }
  backButton = display.newRoundedRect(sceneGroup, screenWidth - 35, 15, 50, 50, 4)
  backButton:setFillColor(0.1, 0.1, 0.1, 1)
  backButton:setStrokeColor(0.8, 0.8, 1, 1)
  backButton.strokeWidth = 2
  backButton.fill = paint
  backButton:addEventListener("tap", gotoMenu)
  
  -- Create a settings menu
  local settingsParameters = 
  {
    x = 35,
    y = 15,
    width = 45,
    height = 45,
    margin = 10
  }
  
  settingsMenu = settings.new(settingsParameters)
  sceneGroup:insert(settingsMenu)
  
  -- Set elements to main sceneGroup
  sceneGroup:insert(guiGroup)
end

-- Loading score from previous session.
function setScoreToPannel( score )
  ledPannel:setScore(score)
  ledPannel:setState("Start")
end

function InitGame()
  local game = game.new()
  game:loadScore()
  setScoreToPannel(game:getScore())
end

function createGame(sceneGroup)
  createBackground(sceneGroup)
  createGrid(sceneGroup)
  createUI(sceneGroup)
  InitGame()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    createGame(sceneGroup)
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
      if userScore < 1 then
        --insertRandomNumberToRandomSequence()
        --activateTimer = timer.performWithDelay( 1000, showSequence, 0)
      else
        --Runtime:addEventListener("touch", resetGame)
      end
      -- Code here runs when the scene is entirely on screen
    end
end

-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is on screen (but is about to go off screen)
      --timer.cancel( activateTimer )
    elseif ( phase == "did" ) then
      --Runtime:removeEventListener( "touch", resetGame )
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