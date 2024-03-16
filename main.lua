--globalvariable
require("src/globals/!globals")
--load block and tiles
LoadBlocksAndTiles("src/blocksandtiles")
function love.run()
	if love.load then
		love.load(Loveargs.parseGameArguments(arg), arg)
	end
	if Lovetimer then
		Lovetimer.step()
	end
	local dt = 0
	return function()
		if Loveevent then
			Loveevent.pump()
			for name, a, b, c, d, e, f in Loveevent.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				Lovehandlers[name](a, b, c, d, e, f)
			end
		end
		if Lovetimer then
			dt = Lovetimer.step()
		end
		if love.update then
			love.update(dt)
		end
		if Lovegraphics and Lovegraphics.isActive() then
			Lovegraphics.origin()
			Lovegraphics.clear(Lovegraphics.getBackgroundColor())
			if love.draw then
				love.draw()
			end
			Lovegraphics.present()
		end
	end
end
function FixHudHotbarandTileScaling()
	local scaleCoefficient = 0.7

	InterfaceWidth = Lovegraphics.getWidth() * scaleCoefficient
	InterfaceHeight = Lovegraphics.getHeight() * scaleCoefficient
end
function love.load()
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainload")
	Lovefilesystem.setIdentity("LuaCraft")
	InitializeGame()
	FixHudHotbarandTileScaling()
	_JPROFILER.pop("Mainload")
	_JPROFILER.pop("frame")
end

function love.textinput(text)
	if Gamestate == GamestatePlayingGame and EnableCommandHUD == true then
		CurrentCommand = CurrentCommand .. text
	end
end

function love.resize(w, h)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainresize")
	if Gamestate == GamestatePlayingGame then
		local scaleX = w / GraphicsWidth
		local scaleY = h / GraphicsHeight
		Lovegraphics.scale(scaleX, scaleY)
		local newCanvas = Lovegraphics.newCanvas(w, h)

		Lovegraphics.setCanvas(newCanvas)
		Lovegraphics.draw(Scene.twoCanvas)
		Lovegraphics.setCanvas()

		Scene.twoCanvas = newCanvas
	end
	local scaleCoefficient = 0.7
	InterfaceWidth = w * scaleCoefficient
	InterfaceHeight = h * scaleCoefficient
	_JPROFILER.pop("Mainresize")
	_JPROFILER.pop("frame")
end

function love.update(dt)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainUpdate")
	updateMovementKeyValues()
	UpdateGame(dt)
	if HudTimeLeft > 0 then
		HudTimeLeft = HudTimeLeft - dt
		if HudTimeLeft <= 0 or Gamestate ~= GamestatePlayingGame then
			hudMessage = ""
		end
	end
	_JPROFILER.pop("MainUpdate")
	_JPROFILER.pop("frame")
end

function love.draw()
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")
	DrawGame()
	if hudMessage ~= nil then
		local width, height = Lovegraphics.getDimensions()
		local font = Lovegraphics.getFont()

		-- Calculate the width and height of the text
		local textWidth = font:getWidth(hudMessage)
		local textHeight = font:getHeight(hudMessage)

		-- Calculate the position to center the text
		local x = (width - textWidth) / 2
		local y = (height - textHeight) / 2 + 280

		Lovegraphics.print(hudMessage, x, y)
	end
	_JPROFILER.pop("MainDraw")
	_JPROFILER.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainmousemoved")
	-- forward mouselook to Scene object for first person camera control
	if Gamestate == GamestatePlayingGame then
		Scene:mouseLook(x, y, dx, dy)
	end
	_JPROFILER.pop("Mainmousemoved")
	_JPROFILER.pop("frame")
end

function love.wheelmoved(x, y)
	if FixinputforDrawCommandInput == false then
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
	_JPROFILER.write("_JPROFILER.mpack")
end
