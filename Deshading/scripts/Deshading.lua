
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 2000 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create("viewer2D1")

-- Seting up graphical overlay attributes

local textDecoration = View.TextDecoration.create()
textDecoration:setSize(40)
textDecoration:setPosition(20, 40)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  local img = Image.load('resources/WhiteSheet.bmp')
  viewer:clear()
  viewer:addImage(img)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Converting to float for enabling arithmetic operations
  local imgF = img:toType('FLOAT32')

  -- Creating normalized scale factor image from reference image
  local rect = Image.PixelRegion.createRectangle(0, 0, 639, 479) -- Full-image region
  local _, _, mean, _ = rect:getStatistics(imgF) -- Retrieving mean intensity
  local imgScale = imgF:pow(-1) -- pow(x,-1) = 1/x for each pixel
  local imgScaleNorm = imgScale:multiplyConstant(mean) -- Normalizing by mean intensity

  -- Testing deshading on reference image
  local imgDeshaded = imgF:multiply(imgScaleNorm)
  viewer:clear()
  local imageID = viewer:addImage(imgDeshaded)
  viewer:addText('Deshaded', textDecoration, nil, imageID)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Deshading of "live" image
  local liveImg = Image.load('resources/CornFlakes.bmp')
  viewer:clear()
  viewer:addImage(liveImg)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  local liveImgDeshaded = Image.multiply(liveImg:toType('FLOAT32'), imgScaleNorm)
  viewer:clear()
  imageID = viewer:addImage(liveImgDeshaded)
  viewer:addText('Deshaded', textDecoration, nil, imageID)
  viewer:present()

  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
