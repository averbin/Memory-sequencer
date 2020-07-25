local composer = require( "composer" )
local effects = require( "effects" )
local grid = require( "grid" )
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
local userCount = 0
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
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function insertRandomNumberToRandomSequence()
  local var = math.random(4)
  table.insert(randSequence, var)
end

local function showSequence( event )
  if isPlayer == false then
    local thisRect = rects[randSequence[numSequence]]
    if numSequence <= #randSequence then
      effects.sequenceBlinking(thisRect.insideRect)
      numSequence = numSequence + 1
    else
      isPlayer = true
      numSequence = 1
      text.text = rectSymbol
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
    if userCount > gameSettings.highScore then
      gameSettings.highScore = userCount
      loadsave.saveTable( gameSettings, "settings.json")
    end
    
    numSequence = 1
    userCount = 0
    countText.text = userCount
    isPlayer = false
    
    for i = 1, #rects do
      effects.cancel(rects[i].insideRect)
    end
    
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
    local userNumber = tonumber(target.id)
    if ( isSequencesTheSame(userNumber)) then
      table.insert(userSequence, userNumber)
      numSequence = numSequence + 1
      userCount = userCount + 1
      countText.text = userCount
      if #userSequence >= #randSequence then
        count = 1
        numSequence = 1
        isPlayer = false
        text.text = playSymbol
        insertRandomNumberToRandomSequence()
        --timer.resume(activateTimer)
        cleanSequence(userSequence)
      end
    else
      timer.pause( activateTimer )
      text.text = "lose"
      isPlayer = false
      for i = 1, #rects do
        effects.cancel(rects[i].insideRect)
        effects.blinkingRepeatedly(rects[i].insideRect)
      end
      Runtime:addEventListener("touch", resetGame)
    end
  end
end

function createButton(group, name, x, y, width, height, shape, cornerRadius, cellColor)
  local newButton = toolButton.new(
    {
      name = name,
      x = x,
      y = y,
      width = width,
      height = height,
      cornerRadius = cornerRadius,
      fillColor = cellColor or { 1,	1, 1, 1 },
      strokeColor = { 0.8, 0.8, 1, 1 },
    }
  )
  table.insert(rects, newButton)
  newButton.insideRect:addEventListener("tap", handleButtonEvent)
  group:insert(newButton.group)
  return newButton 
end

-- Setting background image
function createBackground( sceneGroup )
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screenWidth, screenHeight)
  backgroundImage.x = centerX
  backgroundImage.y = centerY
end

-- TODO: Will be replaced with grid table.
function createGrid( sceneGroup )
  -- Rect group
  rectGroup = display.newGroup()

  local radius = 75
  local width = 100
  local height = 100
  local cornerRadius = 5
  -- Code here runs when the scene is first created but has not yet appeared on screen
  --[[
    x 0
    0 0
  ]]--
  upperLeftButton = createButton(rectGroup, "1",
    display.contentCenterX - radius, display.contentCenterY - radius,
    width, height, "roundedRect", cornerRadius, convertRGBtoRange({ 70, 142, 218, 1.0}))
  --[[
    0 x
    0 0
  ]]--
  upperRightButton = createButton(rectGroup, "2",
    display.contentCenterX + radius,
    display.contentCenterY - radius, 
    width, height, "roundedRect", cornerRadius, convertRGBtoRange({ 218, 190, 70, 1.0}))

  --[[
    0 0
    x 0
  ]]--
  downLeftButton = createButton(rectGroup, "3", 
    display.contentCenterX - radius, display.contentCenterY + radius,
    width, height, "roundedRect", cornerRadius, convertRGBtoRange({ 218, 102, 70, 1.0}))
  --[[
    0 0
    0 x
  ]]--
  downRightButton = createButton(rectGroup, "4", 
    display.contentCenterX + radius, display.contentCenterY + radius,
    width, height, "roundedRect", cornerRadius, convertRGBtoRange({	104, 218,	70, 1.0}))
  -- Set elements to main sceneGroup
  sceneGroup:insert(rectGroup)
end

-- TODO: replace with LED screen for score and game state.
function createUI(sceneGroup)
  -- UI Group
  guiGroup = display.newGroup()
  
  countText = display.newText(userCount, display.contentCenterX,
    20, native.systemFont, 40 )
  guiGroup:insert(countText)
  countText.text = "0"
  
  text = display.newText(guiGroup, playSymbol, 
    countText.x + 100,
    countText.y,
  native.systemFont, 40)
  -- Set elements to main sceneGroup
  sceneGroup:insert(guiGroup)
end

-- Loading score from previous session.
function loadScore()
  local loadedSettings = loadsave.loadTable( "settings.json" )
  if loadedSettings and loadedSettings.highScore then
    userCount = loadedSettings.highScore
    countText.text = userCount
  end
end

function createGame(sceneGroup)
  createBackground(sceneGroup)
  createGrid(sceneGroup)
  createUI(sceneGroup)
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
      if userCount < 1 then
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