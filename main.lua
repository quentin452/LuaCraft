Engine = require("engine")
Perspective = require("src/world/perspective")
--blocks
require("src/blocks/TileEntities/tiledata")
--utils
require("src/utils/things")
require("src/utils/math")
require("src/utils/mouselogic")
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

local enableProfiler = false

function love.load()
	if enableProfiler then
		ProFi:start()
	end
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
	if enableProfiler then
		ProFi:stop()
	end
end

function love.mousemoved(x, y, dx, dy)
	-- forward mouselook to Scene object for first person camera control
	Scene:mouseLook(x, y, dx, dy)
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
	if enableProfiler then
		ProFi:writeReport("report.txt")
	end
end
