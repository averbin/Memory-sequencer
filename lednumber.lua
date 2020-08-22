-----------------------------------------------------------------------------------------
--
-- ledNumber.lua in this file you can find implementation of Led number for setting 
-- number.
--
---------------------------------------------------------------------------------------

local effects = require("effects")
local imageSheet = require("numbers")

ledNumber = {}

function ledNumber.new(options)
  local set               = {}
  options                 = options               or {}
  set.group               = options.group
  set.x                   = options.x             or 0
  set.y                   = options.y             or 0
  set.width               = options.width         or 70
  set.height              = options.height        or 128
  
  local backgroundImgPath = options.backgroundImg or ""
  local stencilImgPath    = options.stencilImg    or ""
  set.number              = options.number        or 0
  
  function createImage(parameters)
    local image = display.newImageRect(parameters.group, parameters.imagePath,
      parameters.width, parameters.height)
    image.x = parameters.x
    image.y = parameters.y
    return image
  end
  
  function set:createGeneralGroup()
    parameters = 
    { 
      group = self.group,
      imagePath = backgroundImgPath,
      x = self.x, y = self.y,
      width = self.width, height = self.height 
    }
    self.backgroundImg = createImage( parameters )
    
    parameters.imagePath = stencilImgPath
    self.stencilImg = createImage( parameters )
    
    parameters.imagePath = imageSheet[self.number].path
    self.numberImg = createImage( parameters )
    self.numberImg.isVisible = false
  end
  
  function set:setPosition(x , y)
    self.x = self.x + x ; self.group.x = self.x; 
    self.y = self.y + y ; self.group.y = self.y;
  end
  
  function set:getNumber()
    return self.number
  end
  
  function set:blinking()
    effects.simpleBlinking(self.numberImg)
  end
  
  function set:cancel()
    effects.cancel(self.numberImg)
    self.numberImg.alpha = 1.0
  end
  
  function set:setNumById( number )
    parameters = 
    { 
      group = self.group,
      imagePath = imageSheet[number].path,
      x = self.x, y = self.y,
      width = self.width, height = self.height 
    }
    display.remove( self.numberImg )
    self.numberImg = createImage( parameters )
  end
  
  set:createGeneralGroup()
  return set
end

return ledNumber