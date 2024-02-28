lovez = love
lovefilesystem = lovez.filesystem
lovegraphics = lovez.graphics
lovewindow = lovez.window
userDirectory = lovez.filesystem.getUserDirectory()

Engine = require("engine")
--menus
require("src/menus/mainmenu")
require("src/menus/mainmenusettings")
require("src/menus/gameplayingpausemenu")
require("src/menus/playinggamesettings")
require("src/menus/worldcreationmenu")
--blocks
require("src/blocks/TileEntities/tiledata")
--utils
require("src/utils/things")
require("src/utils/math")
require("src/utils/mouselogic")
require("src/utils/usefull")
require("src/utils/filesystem")
require("src/utils/settingshandling")
enablePROFIProfiler = false
ProFi = require("src/utils/ProFi")
--entities
require("src/entities/player")
--world
Perspective = require("src/world/perspective")
require("src/world/lighting")
require("src/world/chunk")
require("src/world/updatelogic")
require("src/world/gen/generator")
require("src/world/gen/caves")
--init
require("src/init/!init")
--client
require("src/client/!draw")
require("src/client/blocks/blockrendering")
require("src/client/blocks/tilerendering")

--libs
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer

gamestateMainMenuSettings = "MainMenuSettings"
gamestateMainMenu = "MainMenu"

gamestatePlayingGame = "PlayingGame"
gamestatePlayingGameSettings = "PlayingGameSettings"

gamestateGamePausing = "GamePausing"

gamestateWorldCreationMenu = "WorldCreationMenu"

gamestate = gamestateMainMenu

enableF3 = false
enableF8 = false
enableTESTBLOCK = false
modelalreadycreated = 0
ChunkBorderAlreadyCreated = 0

--modloader
require("src/modloader/structuremodloader")
require("src/modloader/modloaderinit")
require("src/modloader/functiontags")

LoadMods()
hudTimeLeft = 0
function love.load()
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainload")
	lovefilesystem.setIdentity("LuaCraft")
	InitializeGame()
	_JPROFILER.pop("Mainload")
	_JPROFILER.pop("frame")
end

function love.resize(w, h)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainresize")
	local scaleX = w / GraphicsWidth
	local scaleY = h / GraphicsHeight
	love.graphics.scale(scaleX, scaleY)
	_JPROFILER.pop("Mainresize")
	_JPROFILER.pop("frame")
end

function love.update(dt)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainUpdate")
	UpdateGame(dt)
		if hudTimeLeft > 0 then
			hudTimeLeft = hudTimeLeft - dt
			if hudTimeLeft <= 0 or gamestate ~= gamestatePlayingGame then
				hudMessage = ""
			end
		end
	_JPROFILER.pop("MainUpdate")
	_JPROFILER.pop("frame")
end

function love.draw()
	if enablePROFIProfiler then
		ProFi:start()
	end
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")
	DrawGame()
	if hudMessage ~= nil then
		local width, height = love.graphics.getDimensions()
		local font = love.graphics.getFont()

		-- Calculate the width and height of the text
		local textWidth = font:getWidth(hudMessage)
		local textHeight = font:getHeight(hudMessage)

		-- Calculate the position to center the text
		local x = (width - textWidth) / 2
		local y = (height - textHeight) / 2 + 280

		love.graphics.print(hudMessage, x, y)
	end
	if enablePROFIProfiler then
		ProFi:stop()
	end
	_JPROFILER.pop("MainDraw")
	_JPROFILER.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainmousemoved")
	-- forward mouselook to Scene object for first person camera control
	if gamestate == gamestatePlayingGame then
		Scene:mouseLook(x, y, dx, dy)
	end
	_JPROFILER.pop("Mainmousemoved")
	_JPROFILER.pop("frame")
end

function love.wheelmoved(x, y)
	PlayerInventory.hotbarSelect = math.floor(((PlayerInventory.hotbarSelect - y - 1) % 9 + 1) + 0.5)
end

function love.mousepressed(x, y, b)
	MouseLogicOnPlay(x, y, b)
end

function love.keypressed(k)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainKeypressed")
	KeyPressed(k)
	_JPROFILER.pop("MainKeypressed")
	_JPROFILER.pop("frame")
end

function love.quit()
	if enablePROFIProfiler then
		ProFi:writeReport("report.txt")
	end
	_JPROFILER.write("_JPROFILER.mpack")
end
