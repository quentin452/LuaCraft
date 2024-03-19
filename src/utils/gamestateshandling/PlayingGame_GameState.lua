--main.lua
function GamestatePlayingGameTextInput(text)
	if Gamestate == GamestatePlayingGame and EnableCommandHUD == true then
		CurrentCommand = CurrentCommand .. text
	end
end

function GamestatePlayingGameResize(w, h)
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
end

function GamestatePlayingGameMouseMoved(x, y, dx, dy)
	-- forward mouselook to Scene object for first person camera control
	if Gamestate == GamestatePlayingGame then
		Scene:mouseLook(x, y, dx, dy)
	end
end

--!draw.lua
function GamestatePlayingGameDrawGame()
	if Gamestate == GamestatePlayingGame then
		_JPROFILER.push("DrawGameScene")
		-- draw 3d scene
		Scene:render(true)
		-- draw HUD
		Scene:renderFunction(function()
			DrawHudMain()
		end, false)
		love.graphics.setColor(1, 1, 1)
		DrawCanevas()
		_JPROFILER.pop("DrawGameScene")
	end
end

--updatelogic.lua
function GamestatePlayingGameUpdateGame(dt)
	if Gamestate == GamestatePlayingGame then
		renderdistancevalue()
		PlayerInitIfNeeded()
		UpdateAndGenerateChunks(RenderDistance)
		UpdateLogic(dt)
	end
end

--mouseandkeybindlogic.lua
function GamestatePlayingGameMouseAndKeybindLogic(x, y, b)
	-- Forward mousepress events to all things in ThingList
	if ThingList == nil then
		return
	end
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
	--ThreadLightingChannel:push({ "updateLighting" })
	elseif pos and pos.x and pos.z and pos.y >= WorldHeight and ThePlayer.cursorpos and ThePlayer.cursorHit == true then
		HudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
		HudTimeLeft = 3
	end
	_JPROFILER.pop("MouseLogicOnPlay")
	_JPROFILER.pop("frame")
end
