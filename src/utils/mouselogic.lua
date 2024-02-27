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
		-- chunk:updateModel(cx, cy, cz)
		-- LuaCraftPrintLoggingNormal("---")
		-- LuaCraftPrintLoggingNormal(cx, cy, cz)
		-- LuaCraftPrintLoggingNormal(cx % ChunkSize, cy % SliceHeight, cz % ChunkSize)
	elseif pos.x and pos.z and pos.y >= WorldHeight and ThePlayer.cursorpos and ThePlayer.cursorHit == true then
		hudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
		hudTimeLeft = 3
	end
end

function KeyPressed(k)
	-- simplified hotbar number press code, thanks nico-abram!
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 then
		PlayerInventory.hotbarSelect = numberPress
	end
	if gamestate == gamestateMainMenu then
		_JPROFILER.push("keysinitMainMenu")
		keysinitMainMenu(k)
		_JPROFILER.pop("keysinitMainMenu")
	end
	if gamestate == gamestateMainMenuSettings then
		_JPROFILER.push("keysinitMainMenuSettings")
		keysinitMainMenuSettings(k)
		_JPROFILER.pop("keysinitMainMenuSettings")
	end
	if gamestate == gamestateWorldCreationMenu then
		_JPROFILER.push("keysInitWorldCreationMenu")
		keysInitWorldCreationMenu(k)
		_JPROFILER.pop("keysInitWorldCreationMenu")
	end
	if gamestate == gamestatePlayingGame then
		if k == "escape" then
			gamestate = gamestateGamePausing
		elseif k == "n" then
			--TODO FOR REMOVAL
			GenerateWorld()
		elseif k == "f3" then
			enableF3 = not enableF3
		elseif k == "f8" then
			enableF8 = not enableF8
		elseif k == "f1" then
			enableTESTBLOCK = not enableTESTBLOCK
		end
	end
	if gamestate == gamestateGamePausing then
		_JPROFILER.push("keysinitGamePlayingPauseMenu")
		keysinitGamePlayingPauseMenu(k)
		_JPROFILER.pop("keysinitGamePlayingPauseMenu")
	end
	if gamestate == gamestatePlayingGameSettings then
		_JPROFILER.push("keysinitPlayingMenuSettings")
		keysinitPlayingMenuSettings(k)
		_JPROFILER.pop("keysinitPlayingMenuSettings")
	end
end
