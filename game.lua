-----------------------------------------------------------------------------------------
--
-- In this section we create game board with ui elements.
-- This table should translate to gameboard.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local grid = require( "grid" )
local ledPannel = require( "ledPannel" )
local loadsave = require( "loadsave" )
local level = require( "level" )
local settings = require( "settings" )

math.randomseed( os.time() )

local scene = composer.newScene()

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local userSequence = {}
local randSequence = {} -- 1,2,3,4
level.isPlayer = false
local rectGroup = nil
local guiGroup = nil
local rects = {}
local activateTimer = nil
local userScore = 0
local clock = os.clock
local numSequence = 1
local gameScores = 
{
  [ "four" ]   = 0,
  [ "nine" ]   = 0,
  [ "pairs" ]  = 0,
  [ "shapes" ] = 0
}

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

local function insertRandomNumberToRandomSequence()
  local var = math.random(level.buttons)
  table.insert(randSequence, var)
end

local function showSequence( event )
  if level.isPlayer == false then
    local thisRect = rects[randSequence[numSequence]]
    if numSequence <= #randSequence then
      thisRect:sequenceBlinking()
      numSequence = numSequence + 1
      ledPannel:setState("Play")
    else
      level.isPlayer = true
      numSequence = 1
      ledPannel:setState("Record")
    end
  end
end

local function isSequencesTheSame( userNumber )
  if randSequence[numSequence] == userNumber then
    return true
  end
  return false
end

local function cleanSequence( sequence )
  for i=1, #sequence do sequence[i] = nil end
end

function cleanGame()
  cleanSequence(randSequence)
  cleanSequence(userSequence)
  if userScore > gameScores[level.type] then
    gameScores[level.type] = userScore
    loadsave.saveTable( gameScores, "settings.json")
  end
  
  numSequence = 1
  userScore = 0
  ledPannel:setScore(userScore)
  level.isPlayer = false
  
  for i = 1, #rects do
    rects[i]:cancel()
  end
  
  ledPannel:setState("Reset")
end

function resetGame( event )
  if event.phase == "began" then
    
    cleanGame()
    
    insertRandomNumberToRandomSequence()
    
    if activateTimer then
      timer.resume(activateTimer)
    else
      activateTimer = timer.performWithDelay( 1000, showSequence, 0)
    end
    
    Runtime:removeEventListener( "touch", resetGame )
    return true
  end
end

function gameCallbackEvent( id )
  if ( isSequencesTheSame(id)) then
    table.insert(userSequence, id)
    numSequence = numSequence + 1
    userScore = userScore + 1
    ledPannel:setScore(userScore)
    if #userSequence >= #randSequence then
      timer.performWithDelay(500, function()
          numSequence = 1
          level.isPlayer = false
          insertRandomNumberToRandomSequence()
          --timer.resume(activateTimer)
          cleanSequence(userSequence)
        end)
    end
  else
      timer.pause( activateTimer )
      
      ledPannel:setState("Reset")
      ledPannel:setState("Start")
      
      level.isPlayer = false
      for i = 1, #rects do
        rects[i]:cancel()
        rects[i]:blinkingRepeatedly()
      end
      Runtime:addEventListener("touch", resetGame)
  end
end

-- Setting background image
function createBackground( sceneGroup )
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screenWidth, screenHeight)
  backgroundImage.x = centerX
  backgroundImage.y = centerY
end

function createGrid( sceneGroup )
  -- Rect group
  rectGroup = display.newGroup()
  
  if level.type == "four" then
    rows = 2
    columns = 2
  elseif level.type == "nine" then
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
    gameCallbackEvent = gameCallbackEvent,
    typeOfGame = level.type
  } 
  
  fourGrid = grid.new(options)
  fourGrid:create()
  rects = fourGrid:getRects()
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
  
  fourGrid.y = 30
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
function loadScore()
  gameScores = loadsave.loadTable( "settings.json" )
  if gameScores and gameScores[level.type] then
    userScore = gameScores[level.type]
    ledPannel:setScore(userScore)
    ledPannel:setState("Start")
  end
end

function createGame(sceneGroup)
  createBackground(sceneGroup)
  createGrid(sceneGroup)
  createUI(sceneGroup)
  loadScore()
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
        insertRandomNumberToRandomSequence()
        activateTimer = timer.performWithDelay( 1000, showSequence, 0)
      else
        Runtime:addEventListener("touch", resetGame)
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
      timer.cancel( activateTimer )
    elseif ( phase == "did" ) then
      Runtime:removeEventListener( "touch", resetGame )
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