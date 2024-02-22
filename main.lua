lg = love.graphics
lg.setDefaultFilter("nearest")
io.stdout:setvbuf("no")

--dependencies
g3d = require("libs/g3d")
lume = require("libs/lume")
Object = require("libs/classic")
scene = require("libs/scene")
--scenes
require("scenes/gamescene")
--menus
require("menus/mainmenu")
require("menus/mainmenusettings")
require("menus/gameplayingpausemenu")
require("menus/playinggamesettings")
require("menus/worldcreationmenu")
--HUD
require("hud/gamehud")
--things
require("things/usefull")
require("things/chunk")
--profiling
ProFi = require("ProFi")
PROF_CAPTURE = false
_JPROFILER = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft prof.mpack and you will see the viewer

gamestate = "MainMenu"
_font = nil
gameSceneInstance = nil
globalRenderDistance = nil

enableProfiler = false

--Backgrounds
mainMenuBackground = nil
mainMenuSettingsBackground = nil
gameplayingpausemenu = nil
playinggamesettings = nil
worldCreationBackground = nil

globalVSync = love.window.getVSync()

function toggleVSync()
	globalVSync = not globalVSync
	love.window.setVSync(globalVSync and 1 or 0)

	-- Load current contents of config.conf file
	local content, size = love.filesystem.read("config.conf")

	-- Update vsync value in content
	content = content:gsub("vsync=%d", "vsync=" .. (globalVSync and "1" or "0"))

	-- Rewrite config.conf file with updated content
	love.filesystem.write("config.conf", content)
end

function renderdistanceSetting()
	-- Load current contents of config.conf file
	local content, size = love.filesystem.read("config.conf")

	-- Increment the value of globalRenderDistance by 5
	globalRenderDistance = globalRenderDistance + 5

	-- Check if the value exceeds 25, reduce it to 5
	if globalRenderDistance > 25 then
		globalRenderDistance = 5
	end

	-- Update renderdistance value in content using regular expression
	content = content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)

	-- Rewrite config.conf file with updated content
	love.filesystem.write("config.conf", content)
end

function love.load()
	love.filesystem.setIdentity("LuaCraft")
	if globalRenderDistance == nil then
		-- Read the config file
		local content = love.filesystem.read("config.conf")

		-- Extract value
		local renderDistance = tonumber(content:match("renderdistance=(%d+)")) -- Make sure the key is lowercase "renderdistance"

		-- If no value in file, use default value
		if not renderDistance then
			renderDistance = 5
		end

		-- Set global variable
		globalRenderDistance = renderDistance
	end

	if enableProfiler then
		ProFi:start()
	end
	mainMenuBackground = love.graphics.newImage("assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = love.graphics.newImage("assets/backgrounds/Mainmenusettingsbackground.png")
	gameplayingpausemenu = love.graphics.newImage("assets/backgrounds/gameplayingpausemenu.png")
	playinggamesettings = love.graphics.newImage("assets/backgrounds/playinggamesettings.png")
	worldCreationBackground = love.graphics.newImage("assets/backgrounds/WorldCreationBackground.png")

	if love.filesystem.getInfo("config.conf") then
		local content, size = love.filesystem.read("config.conf")

		local vsyncValue = content:match("vsync=(%d)")
		if vsyncValue then
			love.window.setVSync(tonumber(vsyncValue))
		end

		local renderdistanceValue = content:match("renderdistance=(%d)")

		if not renderdistanceValue then
			-- The renderdistance value does not exist, add the default value of 5
			renderdistanceValue = "5"

			-- Add the new line in the config.conf file only if it does not already exist
			if not content:match("renderdistance=") then
				content = content .. "\nrenderdistance=" .. renderdistanceValue

				-- Update config.conf file with new value
				love.filesystem.write("config.conf", content)
			end
		end
	end
end

function love.update(dt)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainUpdate")
	if gamestate == "PlayingGame" then
		if gameSceneInstance and gameSceneInstance.update then
			gameSceneInstance:update(dt)
		end
	end
	_JPROFILER.pop("MainUpdate")
	_JPROFILER.pop("frame")
end

function love.draw()
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")
	setFont()

	if gamestate == "GamePausing" then
		_JPROFILER.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		_JPROFILER.pop("drawGamePlayingPauseMenu")
	end
	if gamestate == "WorldCreationMenu" then
		_JPROFILER.push("drawWorldCreationMenu")
		drawWorldCreationMenu()
		_JPROFILER.pop("drawWorldCreationMenu")
	end
	if gamestate == "PlayingGame" then
		_JPROFILER.push("DrawGameScene")
		if not gameSceneInstance then
			gameSceneInstance = GameScene()
			scene(gameSceneInstance)
		end
		if gameSceneInstance and gameSceneInstance.draw then
			gameSceneInstance:draw()
			drawF3MainGame()
		end
		_JPROFILER.pop("DrawGameScene")
	end

	if gamestate == "MainMenuSettings" then
		_JPROFILER.push("drawMainMenuSettings")
		drawMainMenuSettings()
		_JPROFILER.pop("drawMainMenuSettings")
	end

	if gamestate == "MainMenu" then
		_JPROFILER.push("drawMainMenu")
		drawMainMenu()
		_JPROFILER.pop("drawMainMenu")
	end

	if gamestate == "PlayingGameSettings" then
		_JPROFILER.push("drawPlayingMenuSettings")
		drawPlayingMenuSettings()
		_JPROFILER.pop("drawPlayingMenuSettings")
	end

	_JPROFILER.pop("MainDraw")
	_JPROFILER.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainmousemoved")
	if gamestate == "PlayingGame" then
		_JPROFILER.push("mousemovedDuringGamePlaying")
		if gameSceneInstance and gameSceneInstance.mousemoved then
			gameSceneInstance:mousemoved(x, y, dx, dy)
		end
		_JPROFILER.pop("mousemovedDuringGamePlaying")
	end
	_JPROFILER.pop("Mainmousemoved")
	_JPROFILER.pop("frame")
end

function love.keypressed(k)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainKeypressed")
	if gamestate == "MainMenu" then
		_JPROFILER.push("keysinitMainMenu")
		keysinitMainMenu(k)
		_JPROFILER.pop("keysinitMainMenu")
	end
	if gamestate == "MainMenuSettings" then
		_JPROFILER.push("keysinitMainMenuSettings")
		keysinitMainMenuSettings(k)
		_JPROFILER.pop("keysinitMainMenuSettings")
	end
	if gamestate == "WorldCreationMenu" then
		_JPROFILER.push("keysInitWorldCreationMenu")
		keysInitWorldCreationMenu(k)
		_JPROFILER.pop("keysInitWorldCreationMenu")
	end
	if gamestate == "PlayingGame" then
		if k == "escape" then
			gamestate = "GamePausing"
		end
	end
	if gamestate == "GamePausing" then
		_JPROFILER.push("keysinitGamePlayingPauseMenu")
		keysinitGamePlayingPauseMenu(k)
		_JPROFILER.pop("keysinitGamePlayingPauseMenu")
	end
	if gamestate == "PlayingGameSettings" then
		_JPROFILER.push("keysinitPlayingMenuSettings")
		keysinitPlayingMenuSettings(k)
		_JPROFILER.pop("keysinitPlayingMenuSettings")
	end
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
	_JPROFILER.write("_JPROFILER.mpack")
end
