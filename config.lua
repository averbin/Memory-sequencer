--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

-- if aspect ratio is less than 1.5 then this resolution for a tablet.
local aspectRatio = display.pixelHeight / display.pixelWidth
if  aspectRatio < 1.5 then
  --width for a tablet
  width = 640
else
  --width for a phone
  width = display.pixelWidth
end

application =
{
  content =
  {
    width = width,
    height = width * ratio,
    scale = "letterbox",
    fps = 60,
  },
}