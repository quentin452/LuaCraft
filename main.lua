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
	prof.push("update")
	if gamestate == "PlayingGame" then
		if gameSceneInstance and gameSceneInstance.update then
			gameSceneInstance:update(dt)
		end
	end
	prof.pop("update")
	prof.pop("frame")
end

function love.draw()
	if gamestate == "GamePausing" then
		drawGamePlayingPauseMenu()
	end
	if gamestate == "PlayingGame" then
		prof.push("frame")
		prof.push("PlayingGame")
		if not gameSceneInstance then
			gameSceneInstance = GameScene()
			scene(gameSceneInstance)
		end
		if gameSceneInstance and gameSceneInstance.draw then
			gameSceneInstance:draw()
			drawF3MainGame()
		end
		prof.pop("PlayingGame")
		prof.pop("frame")
	elseif gamestate == "MainMenuSettings" then
		drawMainMenuSettings()
	elseif gamestate == "MainMenu" then
		prof.push("frame")
		drawMainMenu()
		prof.pop("frame")
	elseif gamestate == "PlayingGameSettings" then
		drawPlayingMenuSettings()
	end
	prof.write("prof.mpack")
end

function love.mousemoved(x, y, dx, dy)
	if gamestate == "PlayingGame" then
		if gameSceneInstance and gameSceneInstance.mousemoved then
			gameSceneInstance:mousemoved(x, y, dx, dy)
		end
	end
end

function love.keypressed(k)
	if gamestate == "MainMenu" then
		keysinitMainMenu(k)
	end
	if gamestate == "MainMenuSettings" then
		keysinitMainMenuSettings(k)
	end
	if gamestate == "PlayingGame" then
		if k == "escape" then
			gamestate = "GamePausing"
		end
	end
	if gamestate == "GamePausing" then
		keysinitGamePlayingPauseMenu(k)
	end
	if gamestate == "PlayingGameSettings" then
		keysinitPlayingMenuSettings(k)
	end
end

function love.resize(w, h)
	g3d.camera.aspectRatio = w / h
	g3d.camera.updateProjectionMatrix()
end

function love.quit()
	prof.write("prof.mpack")
end
