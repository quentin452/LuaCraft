require("src/modloader/modloaderinit")
Cpml = require("libs/cpml")

local menussettings = {
	"mainmenusettings",
	"keybindingmenusettings",
}
local menus = {
	"mainmenu",
	"gameplayingpausemenu",
	"worldcreationmenu",
}

local blocks = {
	"tiledata",
}

local utils = {
	"things",
	"math",
	"mouseandkeybindlogic",
	"usefull",
	"filesystem",
	"settingshandling",
	"commands/commandsexec",
}
local utilsthreads = {
	"threadtest",
}
local utilsthreadsloggers = {
	"loggingThreadCreator",
}
local entities = {
	"player",
}

local world = {
	"lighting",
	"updatelogic",
	"gen/generator",
	"gen/caves",
	"utilities/chunkmethods",
	"utilities/voxelsmethods",
}

local worldchunks = {
	"chunkutils",
	"chunkmain",
}
local init = {
	"!init",
}

local client = {
	"huds/!draw",
	"blocks/blockrendering",
	"blocks/tilerendering",
}

local libs = {
	"jprofiler/jprof",
}

local modloader = {
	"modloaderinit",
}

local function requireGroup(group, path)
	for _, v in ipairs(group) do
		require(path .. v)
	end
end
PROF_CAPTURE = false
_JPROFILER = require("libs/" .. libs[1])
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
Ffi = require("ffi")
requireGroup(menussettings, "src/menus/settings/")
requireGroup(menus, "src/menus/")
requireGroup(blocks, "src/blocksandtiles/")
requireGroup(utilsthreadsloggers, "src/utils/threads/loggers/")
requireGroup(utilsthreads, "src/utils/threads/")
requireGroup(utils, "src/utils/")
requireGroup(entities, "src/entities/")
Perspective = require("src/client/huds/perspective")
requireGroup(worldchunks, "src/world/chunks/")
requireGroup(world, "src/world/")
requireGroup(init, "src/init/")
requireGroup(client, "src/client/")
requireGroup(modloader, "src/modloader/")
Engine = require("engine")

menussettings = nil
menus = nil
blocks = nil
utils = nil
utilsthreads = nil
utilsthreadsloggers = nil
entities = nil
world = nil
worldchunks = nil
init = nil
client = nil
libs = nil
modloader = nil
