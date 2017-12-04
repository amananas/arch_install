local git = require("git")

local function makeAurPkg(name)
  printout("Making " .. name .. " ...", "")
  debug("Making " .. name)
  if exec("cd " .. sourceTempLocation .. "/" .. name .. " && makepkg -sr --noconfirm") then
    printok("OK")
    debug("Making " .. name .. " OK")
    return true
  else
    printerr("KO")
    debug("Making " .. name .. " KO")
    return false
  end
end

local function checkRepos(aurPackages)
  printout("Checking AUR packages urls.")
  debug("Checking AUR packages urls.")
  inctab()
  
  local i = 1
  while i <= #aurPackages do
    if git.checkRepo(aurPackages[i].url) then
      i = i+1
    else
      debug("Package with URL " .. aurPackages[i].url .. " will NOT be upgraded.")
      table.remove(aurPackages, i)
    end
  end
  
  dectab()
  debug("Checking AUR packages urls done.")
  printout("Checking AUR packages urls done.\n\n")
end

local function setPackagesName(aurPackages)
  debug("Setting AUR packages name.")
  for _,package in ipairs(aurPackages) do
    package.name = git.getRepoName(package.url)
    debug(package.url .. " name: " .. package.name)
  end
  debug("Setting AUR packages name done.")
end

local function retrievePackages(aurPackages)
  printout("Retrieving AUR packages.")
  debug("Retrieving AUR packages.")
  inctab()

  local i = 1
  while i <= #aurPackages do
    if git.clone(aurPackages[i].url, aurPackages[i].name) then
      i = i+1
    else
      debug("Package " .. aurPackages[i].name .. " will NOT be upgraded.")
      table.remove(aurPackages, i)
    end
  end
  dectab()
  printout("Retrieving AUR packages done.\n\n")
  debug("Retrieving AUR packages done.")
end

local function makepkg(aurPackages)
  printout("Making AUR packages.")
  debug("Making AUR packages.")
  inctab()

  local i = 1
  while i <= #aurPackages do
    if makeAurPkg(aurPackages[i].name) then
      i = i+1
    else
      debug("Package " .. aurPackages[i].name .. " will NOT be upgraded.")
      table.remove(aurPackages, i)
    end
  end
  dectab()
  printout("Making AUR packages done.\n\n")
  debug("Making AUR packages done.")
end


return {
  checkRepos = checkRepos,
  setPackagesName = setPackagesName,
  retrievePackages = retrievePackages,
  makepkg = makepkg
}