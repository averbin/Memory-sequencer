ledNumber = {}

function ledNumber.new(options)
  set = {}
  setmetatable(set, {})
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
  
  function createImage(imagePath)
    image = display.newImageRect(group, imagePath, width, height)
    image.x = x_
    image.y = y_
  end
  
  function createGeneralGroup()
    set.group = group
    set.backgroundImg = createImage(backgroundImg)
    set.stencilImg = createImage(stencilImg)
    print("ID: " .. id)
    print("path: " .. numbers[id].path)
    set.numberImg = createImage(numbers[id].path)
  end
  
  function ledNumber:x()
    return x_
  end
  
  function ledNumber:y()
    return y_
  end
  
  function ledNumber:setPosition(x , y)
    x_ = x_ + x ; group.x = set.x_; 
    y_ = y_ + y ; group.y = set.y_;
  end
  
  function dump()
    print("x: " .. x_)
    print("y: " .. y_)
    print("group x : " .. group.x)
    print("group y : " .. group.y)
  end
  
  createGeneralGroup()
  return set
end

return ledNumber