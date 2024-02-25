function MouseLogicOnPlay(x, y, b)
	-- forward mousepress events to all things in ThingList
	for i = 1, #ThingList do
		local thing = ThingList[i]
		thing:mousepressed(b)
	end

	-- handle clicking to place / destroy blocks
	local pos = ThePlayer.cursorpos
	local value = 0

	if b == 2 then
		pos = ThePlayer.cursorposPrev
		value = PlayerInventory.items[PlayerInventory.hotbarSelect]
	end

	local cx, cy, cz = pos.x, pos.y, pos.z
	local chunk = pos.chunk
	if chunk ~= nil and ThePlayer.cursorpos.chunk ~= nil and ThePlayer.cursorHit then
		chunk:setVoxel(cx, cy, cz, value, true)
		LightingUpdate()
		UpdateChangedChunks()
		--chunk:updateModel(cx,cy,cz)
		--print("---")
		--print(cx,cy,cz)
		--print(cx%ChunkSize,cy%SliceHeight,cz%ChunkSize)
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