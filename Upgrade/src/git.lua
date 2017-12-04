local function checkRepo(url)
  printout("Checking " .. url .. " ... ", "")
  debug("Checking " .. url)
  if (exec("git ls-remote " .. url .. " | grep 'HEAD'")) then 
    printok("OK")
    debug("Checking " .. url .. " OK")
    return true
  else
    printerr("KO")
    debug("Checking " .. url .. " KO")
    return false
  end
end

local function getRepoName(url)
  return string.gsub(url,".*/(.*)%.git$","%1")
end

local function clone(url, name)
  printout("Cloning into " .. name .. " ...", "")
  debug("Cloning " .. url .. " into " .. name)
  if exec("git clone " .. url .. " " .. sourceTempLocation .. "/" .. name) then
    printok("OK")
    debug("Cloning " .. url .. " into " .. name .. " OK")
    return true
  else
    printerr("KO")
    debug("Cloning " .. url .. " into " .. name .. " KO")
    return false
  end
end

return {
  checkRepo = checkRepo,
  getRepoName = getRepoName,
  clone = clone
}