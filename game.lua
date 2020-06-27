local composer = require( "composer" )
local widget = require( "widget" )
local grid = require( "grid" )
local toolButton = require( "toolButton" )
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
local iteration = 0
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function InsertRandomNumberToRandomSequence()
  local var = math.random(4)
  table.insert(randSequence, var)
end

local function ShowSequence( event )
  if isPlayer == false then
    local thisRect = rects[randSequence[numSequence]]
    if numSequence <= #randSequence then
      thisRect.group:blink(tostring(randSequence[numSequence]))
      numSequence = numSequence + 1
    else
      isPlayer = true
      numSequence = 1
      text.text = rectSymbol
      timer.pause(activateTimer)
      iteration = iteration + 1
      print("iteration: " .. iteration)
    end
  end
end

local function IsSequencesTheSame( userNumber )
  if randSequence[numSequence] == userNumber then
    return true
  end
  return false
end

local function CleanSequence( sequence )
  for i=1, #sequence do sequence[i] = nil end
end

function handleButtonEvent( event )
  local target = event.target
  target:blink(target.id)
  local userNumber = tonumber(target.id)
  if (isPlayer == true and IsSequencesTheSame(userNumber)) then
    table.insert(userSequence, userNumber)
    numSequence = numSequence + 1
    userCount = userCount + 1
    countText.text = userCount
    if #userSequence >= #randSequence then
      count = 1
      numSequence = 1
      isPlayer = false
      text.text = playSymbol
      InsertRandomNumberToRandomSequence()
      timer.resume(activateTimer)
      CleanSequence(userSequence)
    end
    --CleanSequence(userSequence)
  else
    print( "incorrect")
    timer.pause( activateTimer )
    text.text = "lose"
  end
end

function CreateButton(group, name, x, y, width, height, shape, cornerRadius)
  local newButton = toolButton.new(
    {
      name = name,
      x = x,
      y = y,
      width = width,
      height = height,
      cornerRadius = cornerRadius,
      fillColor = { 1, 1, 1, 1 },
      strokeColor = { 0.8, 0.8, 1, 1 },
    }
  )
  table.insert(rects, newButton)
  newButton.group:addEventListener("tap", handleButtonEvent)
  group:insert(newButton.group)
  return newButton 
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Setting background image
    local backgroundImage = display.newImageRect( sceneGroup, "img/background.png", screenWidth, screenHeight)
    backgroundImage.x = centerX
    backgroundImage.y = centerY
    
    -- Rect group
    rectGroup = display.newGroup()
    guiGroup = display.newGroup()
    local radius = 75
    local width = 100
    local height = 100
    local cornerRadius = 5
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --[[
      x 0
      0 0
    ]]--
    upperLeftButton = CreateButton(sceneGroup, "1",
      display.contentCenterX - radius, display.contentCenterY - radius,
      width, height, "roundedRect", cornerRadius)
    --[[
      0 x
      0 0
    ]]--
    upperRightButton = CreateButton(sceneGroup, "2",
      display.contentCenterX + radius,
      display.contentCenterY - radius, 
      width, height, "roundedRect", cornerRadius)

    --[[
      0 0
      x 0
    ]]--
    downLeftButton = CreateButton(sceneGroup, "3", 
      display.contentCenterX - radius, display.contentCenterY + radius,
      width, height, "roundedRect", cornerRadius)
    --[[
      0 0
      0 x
    ]]--
    downRightButton = CreateButton(sceneGroup, "4", 
      display.contentCenterX + radius, display.contentCenterY + radius,
      width, height, "roundedRect", cornerRadius)
    
    countText = display.newText( userCount, display.contentCenterX,
      20, native.systemFont, 40 )
    guiGroup:insert(countText)
    
    text = display.newText( guiGroup, playSymbol, 
      countText.x + 100,
      countText.y,
    native.systemFont, 40)
    
    sceneGroup:insert(guiGroup)

    InsertRandomNumberToRandomSequence()
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
      activateTimer = timer.performWithDelay( 1000, ShowSequence, 0)
      -- transition.blink(text, { time = 2000, iterations=4 })
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