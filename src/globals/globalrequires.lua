require("src/modloader/modloaderinit")
Cpml = require("libs/cpml")
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
Ffi = require("ffi")
Perspective = require("src/client/huds/perspective")
Engine = require("engine")

local modules = {
	"blocksandtiles/tiledata",
	"utils/things",
	"utils/math",
	"utils/mouseandkeybindlogic",
	"utils/usefull",
	"utils/filesystem",
	"utils/settingshandling",
	"utils/commands/commandsexec",
	"client/huds/drawhud",
	"client/models/debug/drawhudtest",
	"client/models/debug/chunkbordermodelling",
	"utils/gamestateshandling/GameStateBase",
	"utils/gamestateshandling/GameStateGamePausing",
	"utils/gamestateshandling/GameStateKeybindingMainMenuSettings",
	"utils/gamestateshandling/GameStateKeybindingPlayingGameSettings",
	"utils/gamestateshandling/GameStateMainMenu",
	"utils/gamestateshandling/GameStateMainMenuSettings",
	"utils/gamestateshandling/GameStatePlayingGame",
	"utils/gamestateshandling/GameStatePlayingGameSettings",
	"utils/gamestateshandling/GameStateWorldCreationMenu",
	"utils/gamestateshandling/!PlayingOrSetGameState",
	"utils/threads/!testings/threadtest",
	"utils/threads/loggers/loggingThreadCreator",
	"utils/threads/!testings/chunkhashtable/chunkhashtableThreadCreator",
	"utils/threads/modeling/blockmodellingThreadCreator",
	"utils/threads/lighting/lightingThreadCreator",
	"entities/player",
	"world/lighting",
	"world/updatelogic",
	"world/gen/generator",
	"world/gen/caves",
	"world/utilities/chunkmethods",
	"world/utilities/voxelsmethods",
	"world/chunks/chunkutils",
	"world/chunks/chunkmain",
	"init/!init",
	"client/models/blocks/tilerendering",
	"client/models/blocks/blockrendering",
	"modloader/modloaderinit",
}
local function requireGroup(group, path)
	if type(group) == "table" then
		for _, moduleName in ipairs(group) do
			requireGroup(moduleName, path)
		end
	elseif type(group) == "string" then
		require(path .. group)
	else
		error("Invalid group type: " .. type(group))
	end
end
for _, moduleGroup in ipairs(modules) do
	requireGroup(moduleGroup, "src/")
end
modules = nil
