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

gamestate = 0

function love.load()
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
		end

		-- Affichage des coordonnées et des points cardinaux
		local w, h = love.graphics.getDimensions()
		local font = love.graphics.getFont()

		-- Coordonnées de la caméra
		local camX, camY, camZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Coordonnées :", w - 150, 10)
		love.graphics.print("X: " .. math.floor(camX), w - 150, 30)
		love.graphics.print("Y: " .. math.floor(camY), w - 150, 50)
		love.graphics.print("Z: " .. math.floor(camZ), w - 150, 70)

		-- Coordonnées de la cible de la caméra (où le joueur regarde)
		local targetX, targetY, targetZ = g3d.camera.target[1], g3d.camera.target[2], g3d.camera.target[3]
		--love.graphics.print("Regarde vers :", w - 150, 90)
		-- love.graphics.print("X: " .. math.floor(targetX), w - 150, 110)
		--love.graphics.print("Y: " .. math.floor(targetY), w - 150, 130)
		-- love.graphics.print("Z: " .. math.floor(targetZ), w - 150, 150)

		-- Points cardinaux
		love.graphics.print("Points cardinaux :", w - 150, 170)
		local cardinalPoints = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
		local cameraAngle = math.atan2(targetY - camY, targetX - camX)
		local index = math.floor((cameraAngle + math.pi / 8) / (math.pi / 4)) % 8 + 1
		local currentCardinalPoint = cardinalPoints[index]
		love.graphics.print("Direction : " .. currentCardinalPoint, w - 150, 190)
	else
		drawMainMenu()
	end
end

function love.mousemoved(x, y, dx, dy)
	if _Mainmenu.selection == 1 and _Mainmenu.choice == 1 then
		local scene = scene()
		if scene.mousemoved then
			scene:mousemoved(x, y, dx, dy)
		end
	end
end

function love.keypressed(k)
	if _Mainmenu.selection ~= 0 and _Mainmenu.choice ~= 0 and type(_Mainmenu.choice) == "table" then
		if k == "s" then
			if _Mainmenu.selection < #_Mainmenu.choice then
				_Mainmenu.selection = _Mainmenu.selection + 1
			end
		elseif k == "z" then
			if _Mainmenu.selection > 1 then
				_Mainmenu.selection = _Mainmenu.selection - 1
			end
		elseif k == "return" then
			if _Mainmenu.selection == 1 and type(_Mainmenu.choice) == "table" then
				_Mainmenu.choice = 1
				gamestate = "PlayingGame"
				_font = love.graphics.newFont(15)
				love.graphics.setFont(_font)
			end
		end
	end
	if k == "escape" then
		love.event.push("quit")
	end
end

function love.resize(w, h)
	g3d.camera.aspectRatio = w / h
	g3d.camera.updateProjectionMatrix()
end
