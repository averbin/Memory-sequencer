local colors = require("colors")
local composer = require( "composer" )
local effects = require( "effects" )
local grid = require( "grid" )
local led = require( "ledPannel" )
local loadsave = require( "loadsave" )
local toolButton = require( "toolButton" )
local widget = require( "widget" )

math.randomseed( os.time() )

local scene = composer.newScene()

local screenWidth = display.actualContentWidth
local screenHeight = display.actualContentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local upperLeftButton = nil
local upperRightButton = nil
local downLeftButton = nil
local downRightButton = nil
local userSequence = {}
local randSequence = {} -- 1,2,3,4
local isPlayer = false
local rectGroup = nil
local guiGroup = nil
local rects = {}
local activateTimer = nil
local count = 1
local userScore = 0
local countText = nil
local clock = os.clock
local numSequence = 1
local text = nil -- play, stop, lose 
local playSymbol = "►"
local rectSymbol = "⬤" -- ⬤ - Circle symbol.
local gameSettings = 
{
  highScore = 0
}
local blinkingInProgress = false
local gameType = {id = 9, type = "nine"} -- {id = 9, type = "nine"} , {id = 4, type = "four"}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function insertRandomNumberToRandomSequence()
  local var = math.random(gameType.id)
  table.insert(randSequence, var)
end

function convertUserScore( userScore )
  patern = ""
  local userScoreStr = tostring(userScore)
  
  if(#userScoreStr < 2) then
    userScoreStr = userScoreStr:gsub('()',{[1]='000'})
    print(userScoreStr)
  elseif(#userScoreStr < 3) then
    userScoreStr = userScoreStr:gsub('()',{[1]='00'})
    print(userScoreStr)
  elseif(#userScoreStr < 4) then
    userScoreStr = userScoreStr:gsub('()',{[1]='0'})
    print(userScoreStr)
  end
  
  for i = 1, #userScoreStr do
    patern = patern .. "(%d)"
  end
  
  numbers = {}
  
  local function fromStringToTable(...)
    for i,v in ipairs(arg) do
      if i > 2 then
        numbers[i - 2] = tonumber(v)
      end
    end
    print(numbers)
  end
  
  fromStringToTable(string.find(userScoreStr, patern))
  
  return numbers
end

local function showSequence( event )
  if isPlayer == false then
    local thisRect = rects[randSequence[numSequence]]
    if numSequence <= #randSequence then
      effects.sequenceBlinking(thisRect.insideRect)
      numSequence = numSequence + 1
      led:cancelRecord()
      led:blinkPlay()
    else
      isPlayer = true
      numSequence = 1
      text.text = rectSymbol
      led:cancelPlay()
      led:blinkRecord()
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

function resetGame( event )
  if event.phase == "began" then
    
    cleanSequence(randSequence)
    cleanSequence(userSequence)
    text.text = playSymbol
    if userScore > gameSettings.highScore then
      gameSettings.highScore = userScore
      loadsave.saveTable( gameSettings, "settings.json")
    end
    
    numSequence = 1
    userScore = 0
    led:setScore(convertUserScore(userScore))
    countText.text = userScore
    isPlayer = false
    
    for i = 1, #rects do
      effects.cancel(rects[i].insideRect)
    end
    
    led:cancelPlay()
    led:cancelRecord()
    
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

function handleButtonEvent( event )
  local target = event.target
  if ( isPlayer == true) then
    effects.blink( target )
    -- TODO: set options vibration off/on
    effects.vibrate()
    local userNumber = tonumber(target.id)
    if ( isSequencesTheSame(userNumber)) then
      table.insert(userSequence, userNumber)
      numSequence = numSequence + 1
      userScore = userScore + 1
      led:setScore(convertUserScore(userScore))
      countText.text = userScore
      if #userSequence >= #randSequence then
        timer.performWithDelay(500, function()
            count = 1
            numSequence = 1
            isPlayer = false
            text.text = playSymbol
            insertRandomNumberToRandomSequence()
            --timer.resume(activateTimer)
            cleanSequence(userSequence)
          end)
      end
    else
      timer.pause( activateTimer )
      text.text = "lose"
      
      led:cancelPlay()
      led:cancelRecord()
      led:blinkPlay()
      led:blinkRecord()
      
      isPlayer = false
      effects.vibrate()
      for i = 1, #rects do
        effects.cancel(rects[i].insideRect)
        effects.blinkingRepeatedly(rects[i].insideRect)
      end
      Runtime:addEventListener("touch", resetGame)
    end
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
  
  if gameType.type == "four" then
    rows = 2
    columns = 2
  elseif gameType.type == "nine" then
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
    handleButtonEvent = handleButtonEvent,
    typeOfGame = gameType.type
  } 
  
  fourGrid = grid.new(options)
  fourGrid:create()
  rects = fourGrid:getRects()
  -- Set elements to main sceneGroup
  sceneGroup:insert(rectGroup)
end

-- TODO: replace with LED screen for score and game state.
function createUI(sceneGroup)
  -- UI Group
  guiGroup = display.newGroup()
  
  options = 
  {
    group = guiGroup,
    x = centerX - 50,
    y = 32,
    width = 70,
    height = 128,
  }
  led.new(options)
  
  countText = display.newText(userScore, display.contentCenterX,
    20, native.systemFont, 40 )
  guiGroup:insert(countText)
  countText.text = "0"
  countText.isVisible = false
  
  led:setScore(convertUserScore(userScore))
  text = display.newText(guiGroup, playSymbol, 
    countText.x + 100,
    countText.y,
  native.systemFont, 40)
  text.isVisible = false
  -- Set elements to main sceneGroup
  sceneGroup:insert(guiGroup)
end

-- Loading score from previous session.
function loadScore()
  local loadedSettings = loadsave.loadTable( "settings.json" )
  if loadedSettings and loadedSettings.highScore then
    userScore = loadedSettings.highScore
    led:setScore(convertUserScore(userScore))
    countText.text = userScore
  end
end

function createGame(sceneGroup)
  createBackground(sceneGroup)
  createGrid(sceneGroup)
  createUI(sceneGroup)
  loadScore()
end

function convertRGBtoRange( tab )
  tab[1] = tab[1] / 255
  tab[2] = tab[2] / 255
  tab[3] = tab[3] / 255
  return tab
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