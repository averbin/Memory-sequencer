-----------------------------------------------------------------------------------------
--
-- colors.lua in this file you can find all colors for each game type.
--
-----------------------------------------------------------------------------------------

colors = {}

colors = 
{
  ["four"] = 
  {
    { 70, 142, 218, 1.0},
    { 218, 190, 70, 1.0}, 
    { 218, 102, 70, 1.0}, 
    {	104, 218,	70, 1.0}, 
  },
  ["nine"] =
  {
    {95, 67, 207, 1.0},
    {98, 70, 218, 1.0}, 
    {83, 61, 204, 1.0}, 
    {129, 78, 176, 1.0}, 
    {130, 80, 190, 1.0}, 
    {123, 81, 193, 1.0}, 
    {155, 80, 190, 1.0}, 
    {159, 80, 196, 1.0}, 
    {162, 83, 173, 1.0}, 
  },
  ["shapes"] = 
  {
    {0, 0, 200, 1.0}
  },
}

function convertRGBtoRange( tab )
  local convertedColor= {}
  convertedColor[1] = tab[1] / 255
  convertedColor[2] = tab[2] / 255
  convertedColor[3] = tab[3] / 255
  return convertedColor
end

return colors