lovez = love
lovefilesystem = lovez.filesystem
lovegraphics = lovez.graphics
lovewindow = lovez.window

Engine = require("engine")
Perspective = require("src/world/perspective")
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
ProFi = require("src/utils/ProFi")
--entities
require("src/entities/player")
--world
require("src/world/lighting")
require("src/world/chunk")
require("src/world/updatelogic")
require("src/world/gen/generator")
require("src/world/gen/caves")
--init
require("src/init/!init")
--client
require("src/client/!draw")
--libs
_JPROFILER = require("libs/jprofiler/jprof")

local enablePROFIProfiler = false

PROF_CAPTURE = false
gamestate = "MainMenu"
function love.load()
	if enablePROFIProfiler then
		ProFi:start()
	end
	lovefilesystem.setIdentity("LuaCraft")
	InitializeGame()
end

function love.resize(w, h)
	local scaleX = w / GraphicsWidth
	local scaleY = h / GraphicsHeight
	love.graphics.scale(scaleX, scaleY)
end

function love.update(dt)
	UpdateGame(dt)
end

function love.draw()
	DrawGame()
	if enablePROFIProfiler then
		ProFi:stop()
	end
end

function love.mousemoved(x, y, dx, dy)
	-- forward mouselook to Scene object for first person camera control
	if gamestate == "PlayingGame" then
		Scene:mouseLook(x, y, dx, dy)
	end
end

function love.wheelmoved(x, y)
	PlayerInventory.hotbarSelect = math.floor(((PlayerInventory.hotbarSelect - y - 1) % 9 + 1) + 0.5)
end

function love.mousepressed(x, y, b)
	MouseLogicOnPlay(x, y, b)
end

function love.keypressed(k)
	KeyPressed(k)
end

function love.quit()
	if enablePROFIProfiler then
		ProFi:writeReport("report.txt")
	end
end
