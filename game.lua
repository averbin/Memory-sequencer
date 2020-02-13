local composer = require( "composer" )
local widget = require( "widget" )
math.randomseed( os.time() )

local scene = composer.newScene()

local upperLeftButton = nil
local upperLeftRoundedRect = nil
local upperRightButton = nil
local upperRightRoundedRect = nil
local downLeftButton = nil
local downLeftRoundedRect = nil
local downRightButton = nil
local downRightRoundedRect = nil
local userSequence = {}
local randSequence = {} -- 1,2,3,4
local isPlayer = false
local rectGroup = nil
local guiGroup = nil
local rects = {}
local activateTimer = nil
local deActivateTimer = nil
local count = 1
local userCount = 0
local countText = nil

local clock = os.clock
local numSequence = 1
local text = nil -- play, stop, lose 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function InsertRandomNumberToRandomSequence()
  local var = math.random(4)
  table.insert(randSequence, var)
end

local function ShowRect ( rect )
  rect.isVisible = true
end

local function HideRect ( rect )
  rect.isVisible = false
end

local function ShowSequence( event )
  if isPlayer == false then
    local thisRect = rects[randSequence[numSequence]]
    local switch = count % 2 
    if thisRect ~= nil  and switch > 0 then
      ShowRect(thisRect)
    elseif thisRect ~= nil  and switch == 0 then
      HideRect(thisRect)
      numSequence = numSequence + 1
    end

    count = count + 1
    if numSequence > #randSequence then
      isPlayer = true
      timer.pause( activateTimer )
      count = 1
      numSequence = 1
      text.text = "play"
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

local function handleButtonEvent( event )
  local target = event.target
  if "ended" == event.phase then
    local userNumber = tonumber(target.id)
    if (isPlayer == true and IsSequencesTheSame(userNumber)) then
      table.insert(userSequence, userNumber)
      numSequence = numSequence + 1
      userCount = userCount + 1
      countText.text = userCount
      if numSequence > #randSequence then
        count = 1
        numSequence = 1
        isPlayer = false
        text.text = "sequ"
        InsertRandomNumberToRandomSequence()
        timer.resume(activateTimer)
        CleanSequence(userSequence)
      end
      --activateTimer = timer.performWithDelay( 1000, ShowSequence, 0)
      --CleanSequence(userSequence)
    else
      print( "incorrect")
      timer.pause( activateTimer )
      text.text = "lose"
    end
  end
end

function CreateButton(name, x, y, width, height, shape, cornerRadius)
  local newButton = widget.newButton( 
    {
      id = name,
      shape = shape,
      cornerRadius = cornerRadius,
      width = width,
      height = height,
      fillColor = { default={0, 0, 0, 1}, over={1, 1, 1, 1} },
      strokeColor = { default={1, 1, 1, 1}, over={0.8, 0.8, 1, 1} },
      onEvent = handleButtonEvent,
      strokeWidth = 2
    }
  )
  newButton.x = x
  newButton.y = y
  return newButton 
end

function CreateRect( options )
  local newRect = display.newRoundedRect(
    options.group,
    options.x, options.y,
    options.width, options.height, options.cornerRadius )
  newRect.strokeWidth = 2
  newRect:setFillColor( 1 , 1, 1, 1)
  newRect:setStrokeColor( 0.8, 0.8, 1, 1 )
  newRect.isVisible = false
  return newRect
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    rectGroup = display.newGroup()
    guiGroup = display.newGroup()
    local radius = 75
    local width = 100
    local height = 100
    local cornerRadius = 5
    local options = {
      group = rectGroup,
      x = 0,
      y = 0,
      width = width,
      height = height,
      cornerRadius = cornerRadius,
      fillColor = {1, 1, 1, 1},
      strokeColor = {0.8, 0.8, 1, 1}
      }
    -- Code here runs when the scene is first created but has not yet appeared on screen
    --[[
      x 0
      0 0
    ]]--
    upperLeftButton = CreateButton("1",
      display.contentCenterX - radius, display.contentCenterY - radius,
      width, height, "roundedRect", cornerRadius)
    options.x = upperLeftButton.x
    options.y = upperLeftButton.y
    upperLeftRoundedRect = CreateRect( options )
    --[[
      0 x
      0 0
    ]]--
    upperRightButton = CreateButton("2",
      display.contentCenterX + radius,
      display.contentCenterY - radius, 
      width, height, "roundedRect", cornerRadius)
    options.x = upperRightButton.x
    options.y = upperRightButton.y
    upperRightRoundedRect = CreateRect( options )
    --[[
      0 0
      x 0
    ]]--
    downLeftButton = CreateButton("3", 
      display.contentCenterX - radius, display.contentCenterY + radius,
      width, height, "roundedRect", cornerRadius)
    options.x = downLeftButton.x
    options.y = downLeftButton.y
    downLeftRoundedRect = CreateRect( options )
    --[[
      0 0
      0 x
    ]]--
    downRightButton = CreateButton("4", 
      display.contentCenterX + radius, display.contentCenterY + radius,
      width, height, "roundedRect", cornerRadius)
    options.x = downRightButton.x
    options.y = downRightButton.y
    downRightRoundedRect = CreateRect( options )
    
    table.insert(rects, upperLeftRoundedRect)
    table.insert(rects, upperRightRoundedRect)
    table.insert(rects, downLeftRoundedRect)
    table.insert(rects, downRightRoundedRect)
    
    countText = display.newText( userCount, display.contentCenterX,
      20, native.systemFont, 40 )
    guiGroup:insert(countText)
    
    text = display.newText( guiGroup, "sequ", 
      countText.x + 100,
      countText.y,
    native.systemFont, 40)
    
    sceneGroup:insert(upperLeftButton)
    sceneGroup:insert(upperRightButton)
    sceneGroup:insert(downLeftButton)
    sceneGroup:insert(downRightButton)
    sceneGroup:insert(rectGroup)
    sceneGroup:insert(guiGroup)
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)
      InsertRandomNumberToRandomSequence()
    elseif ( phase == "did" ) then
      activateTimer = timer.performWithDelay( 600, ShowSequence, 0)
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