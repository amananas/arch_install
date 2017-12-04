package.path = package.path .. ";./?.lua"

local aurSources, debSources, customSources = require("package_sources")
helpers = require("helpers")

local aur = require("pkg_aur")
local common = require("pkg_common")

--currentDir=io.popen("echo $(pwd)"):read()

aur.checkRepos(aurSources)
aur.setPackagesName(aurSources)
common.checkExistingDirectories(aurSources)
aur.retrievePackages(aurSources)
aur.makepkg(aurSources)

local packages = common.mergeSourcesLists({aurSources})
common.installPackages(packages)
common.cleanPackages(packages)