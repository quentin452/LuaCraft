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
--HUD
require("hud/gamehud")
--things
require("things/usefull")
require("things/chunk")
--profiling
ProFi = require("ProFi")
PROF_CAPTURE = false
prof = require("libs/jprofiler/jprof")
--profs instruction
--1 : enable PROF_CAPTURE to enable profiler
--2 : profiling some times
--3 : exiting game
--4 : open a CMD on Jprofiler (SRC)
--5 : use this command : love . LuaCraft prof.mpack and you will see the viewer

gamestate = "MainMenu"
_font = nil
mainMenuBackground = nil
mainMenuSettingsBackground = nil
gameplayingpausemenu = nil
playinggamesettings = nil
gameSceneInstance = nil

enableProfiler = false

globalVSync = love.window.getVSync()

function love.load()
	love.filesystem.setIdentity("LuaCraft")
	if enableProfiler then
		ProFi:start()
	end
	mainMenuBackground = love.graphics.newImage("assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = love.graphics.newImage("assets/backgrounds/Mainmenusettingsbackground.png")
	gameplayingpausemenu = love.graphics.newImage("assets/backgrounds/gameplayingpausemenu.png")
	playinggamesettings = love.graphics.newImage("assets/backgrounds/playinggamesettings.png")

	--gameSceneInstance = GameScene()
	--scene(gameSceneInstance)
end

function love.update(dt)
	prof.push("frame")
	prof.push("MainUpdate")
	if gamestate == "PlayingGame" then
		if gameSceneInstance and gameSceneInstance.update then
			gameSceneInstance:update(dt)
		end
	end
	prof.pop("MainUpdate")
	prof.pop("frame")
end

function love.draw()
	prof.push("frame")
	prof.push("MainDraw")

	if gamestate == "GamePausing" then
		prof.push("drawGamePlayingPauseMenu")
		drawGamePlayingPauseMenu()
		prof.pop("drawGamePlayingPauseMenu")
	end

	if gamestate == "PlayingGame" then
		prof.push("DrawGameScene")
		if not gameSceneInstance then
			gameSceneInstance = GameScene()
			scene(gameSceneInstance)
		end
		if gameSceneInstance and gameSceneInstance.draw then
			gameSceneInstance:draw()
			drawF3MainGame()
		end
		prof.pop("DrawGameScene")
	end

	if gamestate == "MainMenuSettings" then
		prof.push("drawMainMenuSettings")
		drawMainMenuSettings()
		prof.pop("drawMainMenuSettings")
	end

	if gamestate == "MainMenu" then
		prof.push("drawMainMenu")
		drawMainMenu()
		prof.pop("drawMainMenu")
	end

	if gamestate == "PlayingGameSettings" then
		prof.push("drawPlayingMenuSettings")
		drawPlayingMenuSettings()
		prof.pop("drawPlayingMenuSettings")
	end

	prof.pop("MainDraw")
	prof.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	prof.push("frame")
	prof.push("Mainmousemoved")
	if gamestate == "PlayingGame" then
		prof.push("mousemovedDuringGamePlaying")
		if gameSceneInstance and gameSceneInstance.mousemoved then
			gameSceneInstance:mousemoved(x, y, dx, dy)
		end
		prof.pop("mousemovedDuringGamePlaying")
	end
	prof.pop("Mainmousemoved")
	prof.pop("frame")
end

function love.keypressed(k)
	prof.push("frame")
	prof.push("MainKeypressed")
	if gamestate == "MainMenu" then
		prof.push("keysinitMainMenu")
		keysinitMainMenu(k)
		prof.pop("keysinitMainMenu")
	end
	if gamestate == "MainMenuSettings" then
		prof.push("keysinitMainMenuSettings")
		keysinitMainMenuSettings(k)
		prof.pop("keysinitMainMenuSettings")
	end
	if gamestate == "PlayingGame" then
		if k == "escape" then
			gamestate = "GamePausing"
		end
	end
	if gamestate == "GamePausing" then
		prof.push("keysinitGamePlayingPauseMenu")
		keysinitGamePlayingPauseMenu(k)
		prof.pop("keysinitGamePlayingPauseMenu")
	end
	if gamestate == "PlayingGameSettings" then
		prof.push("keysinitPlayingMenuSettings")
		keysinitPlayingMenuSettings(k)
		prof.pop("keysinitPlayingMenuSettings")
	end
	prof.pop("MainKeypressed")
	prof.pop("frame")
end

function love.resize(w, h)
	prof.push("frame")
	prof.push("Mainresize")
	g3d.camera.aspectRatio = w / h
	g3d.camera.updateProjectionMatrix()
	prof.pop("Mainresize")
	prof.pop("frame")
end

function love.quit()
	prof.write("prof.mpack")
end
