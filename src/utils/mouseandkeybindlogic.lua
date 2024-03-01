function MouseLogicOnPlay(x, y, b)
	_JPROFILER.push("frame")
	_JPROFILER.push("MouseLogicOnPlay")

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

	if b == 2 and fixinputforDrawCommandInput == false then
		pos = ThePlayer and ThePlayer.cursorposPrev
		value = PlayerInventory.items[PlayerInventory.hotbarSelect] or 0
	end

	local chunk = pos and pos.chunk

	if chunk and ThePlayer and ThePlayer.cursorpos and ThePlayer.cursorHit and pos.y and pos.y < 128 then
		chunk:setVoxel(pos.x, pos.y, pos.z, value, true)
		LightingUpdate()
	elseif pos and pos.x and pos.z and pos.y >= WorldHeight and ThePlayer.cursorpos and ThePlayer.cursorHit == true then
		hudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
		hudTimeLeft = 3
	end
	_JPROFILER.pop("MouseLogicOnPlay")
	_JPROFILER.pop("frame")
end

function KeyPressed(k)
	if k == "f11" then
		toggleFullScreen()
	end
	-- simplified hotbar number press code, thanks nico-abram!
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 and fixinputforDrawCommandInput == false then
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
			if enableCommandHUD then
				fixinputforDrawCommandInput = false
				enableCommandHUD = false
			else
				gamestate = gamestateGamePausing
			end
		elseif k == "f3" then
			enableF3 = not enableF3
		elseif k == "f8" then
			enableF8 = not enableF8
		elseif k == "f1" then
			enableTESTBLOCK = not enableTESTBLOCK
		elseif k == "w" then
			if enableCommandHUD == false then
				CurrentCommand = ""
				enableCommandHUD = true
			end
		elseif k == "backspace" and enableCommandHUD then
			CurrentCommand = string.sub(CurrentCommand, 1, -2)
		elseif k == "return" and enableCommandHUD then
			ExecuteCommand(CurrentCommand)
			CurrentCommand = ""
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
