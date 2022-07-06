-----------------------------------------------------------------------------------------
--
-- utils.lua in this file you can find all general functions.
--
-----------------------------------------------------------------------------------------

local utils = {}

function utils:shallowcopy( orig )
  local origType = type( orig )
  local copy = {}
  if origType == "table" then
    for origKey, origValue in pairs( orig ) do
      copy[origKey] = origValue
    end
  else
    copy = orig
  end
  return copy
end

return utils