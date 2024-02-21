lg = love.graphics
lg.setDefaultFilter("nearest")
io.stdout:setvbuf("no")

g3d = require("libs/g3d")
lume = require("libs/lume")
Object = require("libs/classic")
scene = require("libs/scene")

require("things/chunk")
require("scenes/gamescene")
require("menus/mainmenu")
require("menus/mainmenusettings")
require("hud/gamehud")
require("things/usefull")
ProFi = require("ProFi")
gamestate = "MainMenu"
_font = nil
mainMenuBackground = nil
mainMenuSettingsBackground = nil

enableProfiler = false

function love.load()
	if enableProfiler then
		ProFi:start()
	end
	mainMenuBackground = love.graphics.newImage("assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = love.graphics.newImage("assets/backgrounds/Mainmenusettingsbackground.png")
	scene(GameScene())
end

function love.update(dt)
	if gamestate == "PlayingGame" then
		local scene = scene()
		if scene.update then
			scene:update(dt)
		end
	end
end

function love.draw()
	if gamestate == "PlayingGame" then
		local scene = scene()
		if scene.draw then
			scene:draw()
			drawF3MainGame()
		end
	elseif gamestate == "MainMenuSettings" then
		drawMainMenuSettings()
	else
		drawMainMenu()
	end
	if enableProfiler then
		ProFi:stop()
		ProFi:writeReport("report.txt")
	end
end

function love.mousemoved(x, y, dx, dy)
	if gamestate == "PlayingGame" then
		local scene = scene()
		if scene.mousemoved then
			scene:mousemoved(x, y, dx, dy)
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
	--TODO FOR REMOVAL
	if k == "escape" then
		love.event.push("quit")
	end
end

function love.resize(w, h)
	g3d.camera.aspectRatio = w / h
	g3d.camera.updateProjectionMatrix()
end

function love.quit()
	if enableProfiler then
		ProFi:writeReport("report.txt")
	end
end
