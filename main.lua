math.randomseed(os.time())
lovez = love
lovefilesystem = lovez.filesystem
lovegraphics = lovez.graphics
lovewindow = lovez.window
loveimage = lovez.image
lovetimer = lovez.timer
mathpi = math.pi
userDirectory = lovez.filesystem.getUserDirectory()
luacraftconfig = userDirectory .. ".LuaCraft\\luacraftconfig.txt"

Engine = require("engine")
--menus
require("src/menus/mainmenu")
require("src/menus/mainmenusettings")
require("src/menus/gameplayingpausemenu")
require("src/menus/playinggamesettings")
require("src/menus/worldcreationmenu")
--blocks
require("src/blocksandtiles/tiledata")
--utils
require("src/utils/things")
require("src/utils/math")
require("src/utils/mouseandkeybindlogic")
require("src/utils/usefull")
require("src/utils/filesystem")
require("src/utils/settingshandling")
require("src/utils/commands/commandsexec")
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
require("src/world/utilities/chunkmethods")
require("src/world/utilities/voxelsmethods")

--init
require("src/init/!init")
--client
require("src/client/huds/!draw")
require("src/client/blocks/blockrendering")
require("src/client/blocks/tilerendering")
require("src/client/textures/texturestatic")
--libs
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft _JPROFILER.mpack and you will see the viewer
--modloader
require("src/modloader/modloaderinit")
LoadBlocksAndTiles("src/blocksandtiles")
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
enableCommandHUD = false
fixinputforDrawCommandInput = false
renderdistancegetresetted = true
modelalreadycreated = 0
ChunkBorderAlreadyCreated = 0

hudTimeLeft = 0
function love.run()
	if love.load then
		love.load(love.arg.parseGameArguments(arg), arg)
	end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then
		love.timer.step()
	end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a, b, c, d, e, f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			dt = love.timer.step()
		end

		-- Call update and draw
		if love.update then
			love.update(dt)
		end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then
				love.draw()
			end

			love.graphics.present()
		end

		--		if love.timer then love.timer.sleep(0.001) end
	end
end
function love.load()
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainload")
	lovefilesystem.setIdentity("LuaCraft")
	InitializeGame()
	FixHudHotbarandTileScaling()
	_JPROFILER.pop("Mainload")
	_JPROFILER.pop("frame")
end
CurrentCommand = ""

function love.textinput(text)
	if gamestate == gamestatePlayingGame and enableCommandHUD == true then
		CurrentCommand = CurrentCommand .. text
	end
end

function love.resize(w, h)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainresize")

	local scaleX = w / GraphicsWidth
	local scaleY = h / GraphicsHeight
	lovegraphics.scale(scaleX, scaleY)
	local newCanvas = lovegraphics.newCanvas(w, h)

	lovegraphics.setCanvas(newCanvas)
	lovegraphics.draw(Scene.twoCanvas)
	lovegraphics.setCanvas()

	Scene.twoCanvas = newCanvas

	local scaleCoefficient = 0.7

	InterfaceWidth = w * scaleCoefficient
	InterfaceHeight = h * scaleCoefficient
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
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")
	if enablePROFIProfiler then
		ProFi:start()
	end

	DrawGame()
	if hudMessage ~= nil then
		local width, height = lovegraphics.getDimensions()
		local font = lovegraphics.getFont()

		-- Calculate the width and height of the text
		local textWidth = font:getWidth(hudMessage)
		local textHeight = font:getHeight(hudMessage)

		-- Calculate the position to center the text
		local x = (width - textWidth) / 2
		local y = (height - textHeight) / 2 + 280

		lovegraphics.print(hudMessage, x, y)
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
	if fixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = math.floor(((PlayerInventory.hotbarSelect - y - 1) % 9 + 1) + 0.5)
	end
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
