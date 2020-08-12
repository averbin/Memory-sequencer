ledNumber = {}

function ledNumber.new(options)
  set = {}
  setmetatable(set, {})
  options             = options               or {}
  set.group               = options.group
  set.x_                  = options.x             or 0
  set.y_                  = options.y             or 0
  set.width               = options.width         or 70
  set.height              = options.height        or 128

  set.backgroundImg       = options.backgroundImg or ""
  set.stencilImg          = options.stencilImg    or ""
  set.imagesIndex         = options.numbers
  set.id                  = options.id            or 0
  
  function createImage(imagePath)
    local image = display.newImageRect(set.group, imagePath, set.width, set.height)
    image.x = set.x_
    image.y = set.y_
    image.filename = imagePath
    return image
  end
  
  function createGeneralGroup()
    set.group = group
    set.backgroundImg = createImage(set.backgroundImg)
    set.stencilImg = createImage(set.stencilImg)
    print("ID: " .. set.id )
    print("path: " .. set.imagesIndex[set.id].path)
    set.numberImg = createImage(set.imagesIndex[set.id].path)
  end
  
  function ledNumber:x()
    return set.x_
  end
  
  function ledNumber:y()
    return set.y_
  end
  
  function ledNumber:setPosition(x , y)
    set.x_ = set.x_ + x ; set.group.x = set.x_; 
    set.y_ = set.y_ + y ; set.group.y = set.y_;
  end
  
  function dump()
    print("x: " .. set.x_)
    print("y: " .. set.y_)
    print("group x : " .. set.group.x)
    print("group y : " .. set.group.y)
  end
  
  function set.setNumById( number )
    print("file: " .. set.numberImg.filename)
    display.remove( set.numberImg )
    print("path to image: " .. set.imagesIndex[number].path)
    print("ID: " .. set.id)
    set.numberImg = createImage(set.imagesIndex[number].path)
  end
  
  createGeneralGroup()
  return set
end

return ledNumber