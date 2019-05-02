--[[----------------------------------------------------------------------------

  Application Name:
  Deshading
                                                                                             
  Summary:
  Deshading images based on "white paper" reference image containing shading.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  Restarting the Sample may be necessary to show images after loading the webpage.
  To run this Sample a device with SICK Algorithm API and AppEngine >= V2.5.0 is
  required. For example SIM4000 with latest firmware. Alternatively the Emulator
  in AppStudio 2.3 or higher can be used.
  
  More Information:
  Tutorial "Algorithms - Filtering and Arithmetic".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 2000 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create()
viewer:setID('viewer2D')

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
