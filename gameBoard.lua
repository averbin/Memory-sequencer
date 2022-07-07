-----------------------------------------------------------------------------------------
--
-- In this section we create game board with ui elements.
-- This table should translate to gameboard.lua
-----------------------------------------------------------------------------------------

local composer = require("composer")
local grid = require("grid")
local ledPannel = require("ledPannel")
local gameOptions = require("game")
local settings = require("settings")
local screen = require("screen")
local colors = require("colors")

local scene = composer.newScene()

gameOptions.isPlayer = false
local buttonsGroup = nil
local guiGroup = nil
local buttons = {}
local game = nil

local backButton = nil
local settingsButton = nil


local function gotoMenu()
  game:stopLoop()
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=800, effect="crossFade" })
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Setting background image
function createBackground( sceneGroup )
  local backgroundImage = display.newImageRect(sceneGroup, "img/background.png", screen.width, screen.height)
  backgroundImage.x = screen.centerX
  backgroundImage.y = screen.centerY
end

function createGrid( sceneGroup )
  -- Rect group
  buttonsGroup = display.newGroup()
  
  local options = 
  {
    group = buttonsGroup,
    x = screen.centerX,
    y = screen.centerY,
    width = 250,
    height = 250,
    rows = rows,
    columns = columns, 
    sideMargin = 0,
    rowMargin = 15,
    columnMargin = 15,
    frameOn = false,
    typeOfGame = gameOptions.type
  }

  if gameOptions.type == "four" then
    options.rows = 2
    options.columns = 2
    options.rowMargin = 20
    options.columnMargin = 20
  elseif gameOptions.type == "nine" then
    options.rows = 3
    options.columns = 3
  elseif gameOptions.type == "pairs" then
    options.rows = 2
    options.columns = 2
  elseif gameOptions.type == "shapes" then
    options.rows = 5
    options.columns = 5
    options.rowMargin = 5
    options.columnMargin = 5
  end

  gameOptions.rows = options.rows
  gameOptions.columns = options.columns
  
  gameGrid = grid.new(options)
  gameGrid:create( createBlinkButtonFunc )
  buttons = gameGrid:getButtons()
  -- Set elements to main sceneGroup
  sceneGroup:insert(buttonsGroup)
end

function createUI(sceneGroup)
  -- UI Group
  guiGroup = display.newGroup()
  -- Create a settings menu
  local buttonWidth = (screen.width * 0.15)
  local halfButton = (buttonWidth * 0.5 )
  local oneThird = (buttonWidth / 3 )
  local margin = (screen.width * 0.02)
  local settingsParameters = 
  {
    x = halfButton + margin,
    y = buttonWidth + screen.topSafetyArea,
    width = buttonWidth,
    height = buttonWidth,
    margin = margin
  }

  settingsMenu = settings.new(settingsParameters)

  -- Create a back/home button
  backButton = display.newRoundedRect(settingsMenu,
      screen.width - halfButton - margin, --x
      buttonWidth + screen.topSafetyArea, -- y
      buttonWidth, -- width
      buttonWidth, -- height
      4) -- cornerRadius
  backButton:setFillColor(0.1, 0.1, 0.1, 1)
  backButton:setStrokeColor(unpack(colors['strokeColorButton']))
  backButton.strokeWidth = 2
    -- Create back button
  backButton.fill = {
    type = "image",
    filename = "img/back.png"
  }
  backButton:addEventListener("tap", gotoMenu)
  local ledPositionY = backButton.y + backButton.height * 2
  -- Create led pannel
  options = 
  {
    group = guiGroup,
    x = screen.centerX,
    y = ledPositionY,
    widthElement = buttonWidth,
    heightElement = buttonWidth + oneThird,
    withFrame = true,
    cornerRadius = 4
  }

  ledPannel = ledPannel.new(options)
  ledPannel:setScore( 0 )

  -- Insert groups to main sceneGroup
  sceneGroup:insert(settingsMenu)
  sceneGroup:insert(guiGroup)
end

function createGame(sceneGroup)
  createBackground(sceneGroup)
  --createGrid(sceneGroup)
  
  --game = gameOptions.new({buttons = buttons })
  
  createUI(sceneGroup)
  --game.ledPannel = ledPannel
  
  --game:init()
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  local sceneGroup = self.view
  screen:update()
  createGame(sceneGroup)
end
 
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
      -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
      --game:startLoop()
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