require("src/modloader/modloaderinit")
Cpml = require("libs/cpml")

local menus = {
	"mainmenu",
	"mainmenusettings",
	"gameplayingpausemenu",
	"playinggamesettings",
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

local entities = {
	"player",
}

local world = {
	"lighting",
	"chunk",
	"updatelogic",
	"gen/generator",
	"gen/caves",
	"utilities/chunkmethods",
	"utilities/voxelsmethods",
}

local init = {
	"!init",
}

local client = {
	"huds/!draw",
	"blocks/blockrendering",
	"blocks/tilerendering",
	"textures/texturestatic",
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

requireGroup(menus, "src/menus/")
requireGroup(blocks, "src/blocksandtiles/")
requireGroup(utils, "src/utils/")
requireGroup(entities, "src/entities/")
Perspective = require("src/client/huds/perspective")
requireGroup(world, "src/world/")
requireGroup(init, "src/init/")
requireGroup(client, "src/client/")
PROF_CAPTURE = false
_JPROFILER = require("libs/" .. libs[1])
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
requireGroup(modloader, "src/modloader/")
Engine = require("engine")

menus = nil
blocks = nil
utils = nil
entities = nil
world = nil
init = nil
client = nil
libs = nil
modloader = nil
