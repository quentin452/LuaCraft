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
	love.mouse.setGrabbed(true)
	love.mouse.setVisible(true)
	SetCurrentGameState(GamestateMainMenu2)
	--create_Test_Thread()
	InitializeGame()
	FixHudHotbarandTileScaling()
	_JPROFILER.pop("Mainload")
	_JPROFILER.pop("frame")
end

function love.textinput(text)
	LuaCraftCurrentGameState:textinput(text)
end

function love.resize(w, h)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainresize")
	LuaCraftCurrentGameState:resize(w, h)
	local scaleCoefficient = 0.7
	InterfaceWidth = w * scaleCoefficient
	InterfaceHeight = h * scaleCoefficient
	_JPROFILER.pop("Mainresize")
	_JPROFILER.pop("frame")
end

function love.update(dt)
	_JPROFILER.push("frame")
	_JPROFILER.push("MainUpdate")
	if ResetMovementKeys == true then
		ReLoadMovementKeyValues()
		ResetMovementKeys = false
	end
	UpdateGame(dt)
	if HudTimeLeft > 0 then
		HudTimeLeft = HudTimeLeft - dt
		if HudTimeLeft <= 0 or LuaCraftCurrentGameState ~= GameStatePlayingGame2 then
			HudMessage = ""
		end
	end
	_JPROFILER.pop("MainUpdate")
	_JPROFILER.pop("frame")
end

function love.draw()
	_JPROFILER.push("frame")
	_JPROFILER.push("MainDraw")
	DrawGame()
	if HudMessage ~= nil then
		local width, height = Lovegraphics.getDimensions()
		local font = Lovegraphics.getFont()

		-- Calculate the width and height of the text
		local textWidth = font:getWidth(HudMessage)
		local textHeight = font:getHeight(HudMessage)

		-- Calculate the position to center the text
		local x = (width - textWidth) / 2
		local y = (height - textHeight) / 2 + 280

		Lovegraphics.print(HudMessage, x, y)
	end
	_JPROFILER.pop("MainDraw")
	_JPROFILER.pop("frame")
end

function love.mousemoved(x, y, dx, dy)
	_JPROFILER.push("frame")
	_JPROFILER.push("Mainmousemoved")
	LuaCraftCurrentGameState:mousemoved(x, y, dx, dy)
	_JPROFILER.pop("Mainmousemoved")
	_JPROFILER.pop("frame")
end

function love.wheelmoved(x, y)
	if FixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = math.floor(((PlayerInventory.hotbarSelect - y - 1) % 9 + 1) + 0.5)
	end
end

function love.mousepressed(x, y, b)
	LuaCraftCurrentGameState:mousepressed(x, y, b)
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
