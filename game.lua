local composer = require( "composer" )
local widget = require( "widget" )
math.randomseed( os.time() )
 
local scene = composer.newScene()

local upperLeftButton = nil
local upperRightButton = nil
local downLeftButton = nil
local downRightButton = nil
local userSequence = {}
local randSequence = {}
local turn = "player"
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function handleButtonEvent( event )
  local target = event.target
  if "ended" == event.phase then
    if target.id == upperLeftButton.id then
      print("ID: " .. target.id .. " Upper Left Button was pressed and released" )
    elseif target.id == upperRightButton.id then
      print("ID: " .. target.id .. " Upper Right Button was pressed and released" )
    elseif target.id == downLeftButton.id then
      print("ID: " .. target.id .. " Down Left Button was pressed and released" )
    elseif target.id == downRightButton.id then
      print("ID: " .. target.id .. " Down Right Button was pressed and released" )
    else
      print( "Unrecognized button was pressed and released")
    end
    table.insert(userSequence, target.id)
    for i = 1, table.getn(userSequence) do
      print(userSequence[i])
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
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    local radius = 70
    local width = 100
    local height = 100
    local cornerRadius = 5
    -- Code here runs when the scene is first created but has not yet appeared on screen
    upperLeftButton = CreateButton("1", display.contentCenterX - radius, display.contentCenterY - radius, width, height, "roundedRect", cornerRadius)
    upperRightButton = CreateButton("2", display.contentCenterX + radius, display.contentCenterY - radius, width, height, "roundedRect", cornerRadius)
    downLeftButton = CreateButton("3", display.contentCenterX - radius, display.contentCenterY + radius, width, height, "roundedRect", cornerRadius)
    downRightButton = CreateButton("4", display.contentCenterX + radius, display.contentCenterY + radius, width, height, "roundedRect", cornerRadius)
    
    sceneGroup:insert(upperLeftButton)
    sceneGroup:insert(upperRightButton)
    sceneGroup:insert(downLeftButton)
    sceneGroup:insert(downRightButton)
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