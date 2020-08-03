-----------------------------------------------------------------------------------------
--
-- ledPanel.lua in this file you can find implementation of Led panel for showing
-- score and game state.
--
-----------------------------------------------------------------------------------------

ledPanel = {}

function ledPanel.new( options )
  options = options or {}
  group = options.group
  x = options.x or 0
  y = options.y or 0
  width = options.width or 140 -- width of element is 70 number + game state = 140
  height = options.height or 128 -- height of element is 128
  sections = options.sections or 2 -- how many elements will be on screen including game state.
  local backgroundCell = nil
  local playCell = nil
  local rectCell = nil
  
  local function createGameState()
    backgroundCell = display.newImageRect(group, "img/play_panel.png", width / sections, height)
    playCell = display.newImageRect(group, "img/play_on.png", width / sections, height)
    rectCell = display.newImageRect(group, "img/Record_on.png", width / sections, height)
    group.x = x
    group.y = y
  end
  createGameState()
  
end

return ledPanel