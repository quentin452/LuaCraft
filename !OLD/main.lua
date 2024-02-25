
lovegraphics.setDefaultFilter("nearest")
io.stdout:setvbuf("no")

--libs
g3d = require("libs/g3d")
lume = require("libs/lume")
Object = require("libs/classic")
scene = require("libs/scene")

--client
require("src/client/hud/gamehud")
--utils
require("src/utils/usefull")
require("src/utils/settingshandling")
require("src/utils/filesystem")
--world
require("src/world/chunk/chunk")
require("src/world/scene/gamescenecore")
require("src/world/noise/perlinnoise")
--modloader
require("src/modloader/structuremodloader")
require("src/modloader/modloaderinit")
require("src/modloader/functiontags")

--profiling
ProFi = require("ProFi")
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
--init
require("src/init/structureinit")

LoadMods()

gameSceneInstance = nil

enableProfiler = false

function love.load()
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainload")
	ModLoaderInitALL()
	loadAndSaveLuaCraftFileSystem()
	SettingsHandlingInit()
	if enableProfiler then
		ProFi:start()
	end

	_JPROFILER.pop("Mainload")
	_JPROFILER.pop("frame")
end

function love.update(dt)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainUpdate")

	_JPROFILER.pop("MainUpdate")
	_JPROFILER.pop("frame")
end

function love.draw()
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")

	_JPROFILER.pop("MainDraw")
	_JPROFILER.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainmousemoved")

	_JPROFILER.pop("Mainmousemoved")
	_JPROFILER.pop("frame")
end

function love.keypressed(k)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainKeypressed")
	
	_JPROFILER.pop("MainKeypressed")
	_JPROFILER.pop("frame")
end

function love.resize(w, h)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainresize")
	g3d.camera.aspectRatio = w / h
	g3d.camera.updateProjectionMatrix()
	_JPROFILER.pop("Mainresize")
	_JPROFILER.pop("frame")
end

function love.quit()
	ProFi:writeReport("report.txt")

	_JPROFILER.write("_JPROFILER.mpack")
end
