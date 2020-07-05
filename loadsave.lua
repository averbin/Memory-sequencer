local M = {}

local json = require( "json" )
local defaultLocation = system.DocumentsDirectory

function M.saveTable(t , filename, location)
  local loc = location
  if not location then
    loc = defaultLocation
  end
  
  local path = system.pathForFile( filename, loc )
  local file, errorString = io.open( path, "w")
  
  if not file then
    print("File error: " .. errorString)
    return false
  else
    file:write( json.encode( t ) )
    io.close( file )
  end
  
  return true
end

function M.loadTable( filename, location )
  local loc = location
  if not location then
    loc = defaultLocation
  end
  
  local path = system.pathForFile(filename, loc)
  local file, errorString = io.open(path)
  if not file then
    print("File error: " .. errorString)
  else
    local contents = file:read("*a")
    local t = json.decode(contents)
    io.close(file)
    return t
  end

end

return M