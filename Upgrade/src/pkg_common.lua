local function installPackage(name)
  printout("Installing " .. name .. " ...", "")
  debug("Installing " .. name)
  if exec("cd " .. sourceTempLocation .. "/" .. name .. " && makepkg -ri --noconfirm") then
    printok("OK")
    debug("Installing " .. name .. " OK")
    return true
  else
    printerr("KO")
    debug("Installing " .. name .. " KO")
    return false
  end
end

local function cleanPackage(name)
  printout("Cleaning " .. name .. " sources...", "")
  debug("Cleaning " .. name .. " sources")
  if exec("rm -rf " .. sourceTempLocation .. "/" .. name) then
    printok("OK")
    debug("Cleaning " .. name .. " sources OK")
    return true
  else
    printerr("KO")
    debug("Cleaning " .. name .. " sources KO")
    return false
  end
end



local function checkExistingDirectory(packageName)
  printout("Checking wether " .. packageName .. " directory already exists... ", "")
  debug("Checking wether " .. packageName .. " directory already exists.")
  
  tempfile = io.open(sourceTempLocation .. "/" .. packageName .. "/test.tmp", "w")
  if tempfile then
    debug(packageName .. " exists: KO")
    printerr("yes")
    io.close(tempfile)
    os.remove(sourceTempLocation .. "/" .. packageName .. "/test.tmp")
    return true
  else
    debug(packageName .. " does not exist: OK.")
    printok("no")
    return false
  end
end

local function checkExistingDirectories(packages)
  printout("Checking package directories do not exist already.")
  debug("Checking package directories do not exist already.")
  inctab()

  local i = 1
  while i <= #packages do
    if checkExistingDirectory(packages[i].name) then
      local shouldUpgrade = true
      printout("Delete existing directory " .. sourceTempLocation .. "/" .. packages[i].name .. " (Y/n)? ", "")
      io.flush()
      local answer=io.read()
      if answer == "n" or answer == "N" then
        shouldUpgrade = false
      else
        shouldUpgrade = exec("rm -rf " .. sourceTempLocation .. "/" .. packages[i].name)
      end
      
      if shouldUpgrade == false then
        printout("Package " .. packages[i].name .. " will NOT be upgraded")
        table.remove(packages, i)
        i = i-1
      end
    end
    i = i+1
  end
  
  dectab()
  printout("Checking package directories do not exist already done.\n\n")
  debug("Checking package directories do not exist already done.")
end

local function mergeSourcesLists(sourcesLists)
  local resultList = {}
  for _, list in ipairs(sourcesLists) do
    for _, source in ipairs(list) do
      resultList[#resultList+1] = source
    end 
  end
  return resultList
end

local function installPackages(packagesList)
  printout("Installing packages.")
  debug("Installing packages.")
  inctab()

  local i = 1
  while i <= #packagesList do
    if installPackage(packagesList[i].name) then
      i = i+1
    else
      debug("Package " .. packagesList[i].name .. " will NOT be upgraded.")
      table.remove(packagesList, i)
    end
  end
  dectab()
  printout("Installing packages.\n\n")
  debug("Installing packages.")
end

local function cleanPackages(packagesList)
  printout("Cleaning packages sources.")
  debug("Cleaning packages sources.")
  inctab()

  for _, package in ipairs(packagesList) do
    cleanPackage(package.name)
  end
  
  dectab()
  printout("Cleaning packages sources.\n\n")
  debug("Cleaning packages sources.")
end

return {
  checkExistingDirectories = checkExistingDirectories,
  mergeSourcesLists = mergeSourcesLists,
  installPackages = installPackages,
  cleanPackages = cleanPackages
}