function MouseLogicOnPlay(x, y, b)
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

	if b == 2 then
		pos = ThePlayer and ThePlayer.cursorposPrev
		value = PlayerInventory.items[PlayerInventory.hotbarSelect] or 0
	end

	local cx, cy, cz = pos and pos.x, pos and pos.y, pos and pos.z
	local chunk = pos and pos.chunk

	-- Check if the block is not placed at Y 128
	if chunk and ThePlayer and ThePlayer.cursorpos and ThePlayer.cursorHit and cy and cy < 128 then
		chunk:setVoxel(cx, cy, cz, value, true)
		LightingUpdate()
		UpdateChangedChunks()
		-- chunk:updateModel(cx, cy, cz)
		-- print("---")
		-- print(cx, cy, cz)
		-- print(cx % ChunkSize, cy % SliceHeight, cz % ChunkSize)
	elseif pos.y >= 128 then
		hudMessage = "you cannot place blocks at Y = 128 or more"
		hudTimeLeft = 3
	end
end

function KeyPressed(k)
	--if k == "escape" then
	--	love.event.push("quit")
	--end

	if k == "n" then
		GenerateWorld()
	end

	-- simplified hotbar number press code, thanks nico-abram!
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 then
		PlayerInventory.hotbarSelect = numberPress
	end
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
end
