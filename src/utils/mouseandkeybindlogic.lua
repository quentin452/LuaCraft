function MouseLogicOnPlay(x, y, b)
	_JPROFILER.push("frame")
	_JPROFILER.push("MouseLogicOnPlay")
	if Gamestate == GamestateMainMenu then
		GamestateMainMenuMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestateKeybindingMainSettings then
		GamestateKeybindingMainSettingsMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestateKeybindingPlayingGameSettings then
		GamestateKeybindingPlayingGameSettingsMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestatePlayingGameSettings then
		GamestatePlayingGameSettingsMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestateMainMenuSettings then
		GamestateMainMenuSettingsMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestateWorldCreationMenu then
		GamestateWorldCreationMenuMouseAndKeybindLogic(x, y, b)
	elseif Gamestate == GamestateGamePausing then
		GamestateGamePausingMouseAndKeybindLogic(x, y, b)
	elseif IsPlayingGame() then
		GamestatePlayingGameMouseAndKeybindLogic(x, y, b)
	end
end

function KeyPressed(k)
	if k == "f11" then
		LuaCraftSettingsUpdater("toggleFullScreen")
	end
	-- simplified hotbar number press code, thanks nico-abram!
	local numberPress = tonumber(k)
	if numberPress ~= nil and numberPress >= 1 and numberPress <= 9 and FixinputforDrawCommandInput == false then
		PlayerInventory.hotbarSelect = numberPress
	elseif Gamestate == GamestateMainMenu then
		_JPROFILER.push("keysinitMainMenu")
		keysinitMainMenu(k)
		_JPROFILER.pop("keysinitMainMenu")
	elseif Gamestate == GamestateMainMenuSettings or Gamestate == GamestatePlayingGameSettings then
		_JPROFILER.push("keysinitMenuSettings")
		keysinitMenuSettings(k)
		_JPROFILER.pop("keysinitMenuSettings")
	elseif Gamestate == GamestateKeybindingMainSettings or Gamestate == GamestateKeybindingPlayingGameSettings then
		_JPROFILER.push("keysinitKeybindingSettings")
		keysinitKeybindingSettings(k)
		_JPROFILER.pop("keysinitKeybindingSettings")
	elseif Gamestate == GamestateWorldCreationMenu then
		_JPROFILER.push("keysInitWorldCreationMenu")
		keysInitWorldCreationMenu(k)
		_JPROFILER.pop("keysInitWorldCreationMenu")
	elseif IsPlayingGame() then
		if k == "escape" then
			if EnableCommandHUD then
				FixinputforDrawCommandInput = false
				EnableCommandHUD = false
			else
				love.mouse.setRelativeMode(false)
				love.mouse.setGrabbed(true)
				love.mouse.setVisible(true)
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
	elseif Gamestate == GamestateGamePausing then
		_JPROFILER.push("keysinitGamePlayingPauseMenu")
		keysinitGamePlayingPauseMenu(k)
		_JPROFILER.pop("keysinitGamePlayingPauseMenu")
	end
	if ConfiguringMovementKey then
		if k == "escape" then
			ConfiguringMovementKey = false
		else
			if k ~= "return" then
				local keyToUpdate
				if _KeybindingMenuSettings.selection == 1 then
					keyToUpdate = "forwardmovementkey"
				elseif _KeybindingMenuSettings.selection == 2 then
					keyToUpdate = "backwardmovementkey"
				elseif _KeybindingMenuSettings.selection == 3 then
					keyToUpdate = "leftmovementkey"
				elseif _KeybindingMenuSettings.selection == 4 then
					keyToUpdate = "rightmovementkey"
				end
				if keyToUpdate then
					local forwardKey
					local previousKey = forwardKey
					forwardKey = k
					updateConfigFile(keyToUpdate, forwardKey)
					if forwardKey ~= previousKey then
						ResetMovementKeys = true
						ConfiguringMovementKey = false
					end
				end
			end
		end
	end
end
