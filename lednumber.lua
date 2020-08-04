ledNumber = {}

function ledNumber.new(options)
  options             = options               or {}
  group               = options.group
  x_                  = options.x             or 0
  y_                  = options.y             or 0
  width               = options.width         or 70
  height              = options.height        or 128
  
  backgroundImg       = options.backgroundImg or ""
  stencilImg          = options.stencilImg    or ""
  numbers             = options.numbers
  id                  = options.id            or 1
  
  fullLedNumberGroup  = group                 or display.newGroup()
  
  function createImage(imagePath)
    image = display.newImageRect(fullLedNumberGroup, imagePath, width, height)
    image.x = x_
    image.y = y_
  end
  
  function createGeneralGroup()
    local backgroundImg = createImage(backgroundImg)
    local stencilImg = createImage(stencilImg)
    print("ID: " .. id)
    print("path: " .. numbers[id].path)
    local numberImg = createImage(numbers[id].path)
  
    --fullLedNumberGroup.x = x_; 
    --fullLedNumberGroup.y = y_;
  end
  
  function ledNumber:x()
    return x_
  end
  
  function ledNumber:y()
    return y_
  end
  
  function ledNumber:setPosition(x , y)
    x_ = x_ + x ; fullLedNumberGroup.x = x_; 
    y_ = y_ + y ; fullLedNumberGroup.y = y_;
  end
  
  function dump()
    print("x: " .. x_)
    print("y: " .. y_)
    print("fullLedNumberGroup x : " .. fullLedNumberGroup.x)
    print("fullLedNumberGroup y : " .. fullLedNumberGroup.y)
  end
  
  createGeneralGroup()
  
end

return ledNumber