local debugfileLocation = sourceTempLocation .. "/debug.txt"
local debugfile = nil
local tab = ""

function inctab()
  tab = tab .. "    "
end
function dectab()
  tab = tab:sub(1, tab:len() - 4)
end

function printout(message, ending)
  ending = ending or "\n"
  io.write(tab .. message .. ending)
end
function printerr(message, ending)
  ending = ending or "\n"
  io.write(tab .. "\27[0;31m" .. message .. "\27[0m" .. ending)
end
function printok(message, ending)
  ending = ending or "\n"
  io.write(tab .. "\27[0;32m" .. message .. "\27[0m" .. ending)
end
function debug(message)
  debugfile = io.open(debugfileLocation,"a")
  debugfile:write(message .. "\n")
  io.close(debugfile)
end

function exec(command)
  return os.execute(command .. " >> " .. helpers.debugfileLocation .. " 2>&1")
end


debugfile = io.open(debugfileLocation,"w")
if debugfile == nil then
  printerr("Cannot open debug file. Exiting...")
  os.exit(1)
end
io.close(debugfile)

return {
  debugfileLocation = debugfileLocation,
  debugfile = debugfile
}