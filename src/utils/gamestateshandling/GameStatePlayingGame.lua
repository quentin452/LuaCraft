GameStatePlayingGame2 = GameStateBase:new()
function GameStatePlayingGame2:textinput(text)
	if EnableCommandHUD == true then
		CurrentCommand = CurrentCommand .. text
	end
end
function GameStatePlayingGame2:update(dt)
	renderdistancevalue()
	PlayerInitIfNeeded()
	UpdateAndGenerateChunks(RenderDistance)
	UpdateLogic(dt)
end

function GameStatePlayingGame2:draw()
	_JPROFILER.push("DrawGameScene")
	-- draw 3d scene
	Scene:render(true)
	if WorldSuccessfullyLoaded == true then
		PlayerSuffocationCheck()
	end
	-- draw HUD
	Scene:renderFunction(function()
		DrawHudMain()
	end, false)
	love.graphics.setColor(1, 1, 1)
	DrawCanevas()
	_JPROFILER.pop("DrawGameScene")
end

function GameStatePlayingGame2:mousemoved(x, y, dx, dy)
	Scene:mouseLook(x, y, dx, dy)
end

function GameStatePlayingGame2:resize(w, h)
	local scaleX = w / GraphicsWidth
	local scaleY = h / GraphicsHeight
	Lovegraphics.scale(scaleX, scaleY)
	local newCanvas = Lovegraphics.newCanvas(w, h)
	Lovegraphics.setCanvas(newCanvas)
	Lovegraphics.draw(Scene.twoCanvas)
	Lovegraphics.setCanvas()
	Scene.twoCanvas = newCanvas
end

function GameStatePlayingGame2:mousepressed(x, y, b)
	-- Forward mousepress events to all things in ThingList
	for i = 1, #ThingList do
		local thing = ThingList[i]
		if thing and thing.mousepressed then
			thing:mousepressed(b)
		end
	end
	-- Handle clicking to place / destroy blocks
	local pos = ThePlayer and ThePlayer.cursorpos
	local value = 0
	if b == 2 and FixinputforDrawCommandInput == false then
		pos = ThePlayer and ThePlayer.cursorposPrev
		value = PlayerInventory.items[PlayerInventory.hotbarSelect] or Tiles.AIR_Block.id
	end
	local chunk = pos and pos.chunk
	if chunk and ThePlayer and ThePlayer.cursorpos and ThePlayer.cursorHit and pos.y and pos.y < 128 then
		chunk:setVoxel(pos.x, pos.y, pos.z, value, true)
		LightingUpdate()
	elseif pos and pos.x and pos.z and pos.y >= WorldHeight and ThePlayer.cursorpos and ThePlayer.cursorHit == true then
		HudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
		HudTimeLeft = 3
	end
end

function GameStatePlayingGame2:keypressed(k)
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 and FixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = numberPress
	end
	if k == "escape" then
		if EnableCommandHUD then
			FixinputforDrawCommandInput = false
			EnableCommandHUD = false
		else
			WorldSuccessfullyLoaded = false
			EnableLightningEngineDebug = false
			EnableBlockRenderingTestUnit = false
			BlockModellingTestUnitTimer = 0
			TilesModellingTestUnitTimer = 0
			ChunkTestUnitTimer = 0
			EnableTilesRenderingTestUnit = false
			LightningQueriesTestUnitOperationCounter = nil
			SetCurrentGameState(GamestateGamePausing2)
		end
	elseif k == "f3" then
		EnableF3 = not EnableF3
	elseif k == "f8" then
		EnableF8 = not EnableF8
	elseif k == "f1" then
		--EnableTESTBLOCK = not EnableTESTBLOCK
	elseif k == ChatKey then
		if EnableCommandHUD == false then
			CurrentCommand = ""
			EnableCommandHUD = true
		end
	elseif k == "backspace" and EnableCommandHUD then
		CurrentCommand = string.sub(CurrentCommand, 1, -2)
	elseif k == "return" and EnableCommandHUD then
		ExecuteCommand(CurrentCommand)
		CurrentCommand = ""
	end
end
function GameStatePlayingGame2:setFont()
	return Font15
end
