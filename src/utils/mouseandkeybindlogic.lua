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

	if b == 2 and FixinputforDrawCommandInput == false then
		pos = ThePlayer and ThePlayer.cursorposPrev
		value = PlayerInventory.items[PlayerInventory.hotbarSelect] or Tiles.AIR_Block.id
	end

	local chunk = pos and pos.chunk

	if chunk and ThePlayer and ThePlayer.cursorpos and ThePlayer.cursorHit and pos.y and pos.y < 128 then
		chunk:setVoxel(pos.x, pos.y, pos.z, value, true)
		LightingUpdate()
	elseif pos and pos.x and pos.z and pos.y >= WorldHeight and ThePlayer.cursorpos and ThePlayer.cursorHit == true then
		hudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
		HudTimeLeft = 3
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
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 and FixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = numberPress
	end
	if Gamestate == GamestateMainMenu then
		_JPROFILER.push("keysinitMainMenu")
		keysinitMainMenu(k)
		_JPROFILER.pop("keysinitMainMenu")
	end
	if Gamestate == GamestateMainMenuSettings then
		_JPROFILER.push("keysinitMainMenuSettings")
		keysinitMainMenuSettings(k)
		_JPROFILER.pop("keysinitMainMenuSettings")
	end
	if Gamestate == GamestateWorldCreationMenu then
		_JPROFILER.push("keysInitWorldCreationMenu")
		keysInitWorldCreationMenu(k)
		_JPROFILER.pop("keysInitWorldCreationMenu")
	end
	if Gamestate == GamestatePlayingGame then
		if k == "escape" then
			if EnableCommandHUD then
				FixinputforDrawCommandInput = false
				EnableCommandHUD = false
			else
				Gamestate = GamestateGamePausing
			end
		elseif k == "f3" then
			EnableF3 = not EnableF3
		elseif k == "f8" then
			EnableF8 = not EnableF8
		elseif k == "f1" then
			--EnableTESTBLOCK = not EnableTESTBLOCK
		elseif k == "w" then
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

	if Gamestate == GamestateGamePausing then
		_JPROFILER.push("keysinitGamePlayingPauseMenu")
		keysinitGamePlayingPauseMenu(k)
		_JPROFILER.pop("keysinitGamePlayingPauseMenu")
	end
	if Gamestate == GamestatePlayingGameSettings then
		_JPROFILER.push("keysinitPlayingMenuSettings")
		keysinitPlayingMenuSettings(k)
		_JPROFILER.pop("keysinitPlayingMenuSettings")
	end
end
