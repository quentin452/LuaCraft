function MouseLogicOnPlay(x, y, b)
	_JPROFILER.push("frame")
	_JPROFILER.push("MouseLogicOnPlay")

	GamestateMainMenuMouseAndKeybindLogic(x, y, b)
	if Gamestate == GamestateKeybindingMainSettings then
		if b == 1 then
			local choiceClicked = math.floor((y - _KeybindingMenuSettings.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_KeybindingMenuSettings.choice then
				_KeybindingMenuSettings.selection = choiceClicked
				if choiceClicked == 1 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 2 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 3 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 4 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 5 then
					if Gamestate == GamestateKeybindingMainSettings then
						Gamestate = GamestateMainMenuSettings
						_KeybindingMenuSettings.selection = 0
					elseif Gamestate == GamestateKeybindingPlayingGameSettings then
						Gamestate = GamestatePlayingGameSettings
						_KeybindingMenuSettings.selection = 0
					end
				end
			end
		end
	elseif Gamestate == GamestateKeybindingPlayingGameSettings then
		if b == 1 then
			local choiceClicked = math.floor((y - _KeybindingMenuSettings.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_KeybindingMenuSettings.choice then
				_KeybindingMenuSettings.selection = choiceClicked
				if choiceClicked == 1 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 2 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 3 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 4 then
					ConfiguringMovementKey = true
				elseif choiceClicked == 5 then
					if Gamestate == GamestateKeybindingMainSettings then
						Gamestate = GamestateMainMenuSettings
						_KeybindingMenuSettings.selection = 0
					elseif Gamestate == GamestateKeybindingPlayingGameSettings then
						Gamestate = GamestatePlayingGameSettings
						_KeybindingMenuSettings.selection = 0
					end
				end
			end
		end
	elseif Gamestate == GamestatePlayingGameSettings then
		if b == 1 then
			local choiceClicked = math.floor((y - _MainMenuSettings.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_MainMenuSettings.choice then
				_MainMenuSettings.selection = choiceClicked
				if choiceClicked == 1 then
					LuaCraftSettingsUpdater("toggleVSync")
				elseif choiceClicked == 2 then
					LuaCraftSettingsUpdater("NormalLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 3 then
					LuaCraftSettingsUpdater("WarnLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 4 then
					LuaCraftSettingsUpdater("ErrorLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 5 then
					LuaCraftSettingsUpdater("renderdistanceSetting")
					Renderdistancegetresetted = true
				elseif choiceClicked == 6 then
					if Gamestate == GamestatePlayingGameSettings then
						Gamestate = GamestateKeybindingPlayingGameSettings
						_MainMenuSettings.selection = 0
					elseif Gamestate == GamestateMainMenuSettings then
						Gamestate = GamestateKeybindingMainSettings
						_MainMenuSettings.selection = 0
					end
					_MainMenuSettings.selection = 0
				elseif choiceClicked == 7 then
					if Gamestate == GamestatePlayingGameSettings then
						Gamestate = GamestatePlayingGame
						_MainMenuSettings.selection = 0
					elseif Gamestate == GamestateMainMenuSettings then
						Gamestate = GamestateMainMenu
						_MainMenuSettings.selection = 0
					end
				end
			end
		end
	elseif Gamestate == GamestateMainMenuSettings then
		if b == 1 then
			local choiceClicked = math.floor((y - _MainMenuSettings.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_MainMenuSettings.choice then
				_MainMenuSettings.selection = choiceClicked
				if choiceClicked == 1 then
					LuaCraftSettingsUpdater("toggleVSync")
				elseif choiceClicked == 2 then
					LuaCraftSettingsUpdater("NormalLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 3 then
					LuaCraftSettingsUpdater("WarnLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 4 then
					LuaCraftSettingsUpdater("ErrorLoggingToggler")
					ThreadLogChannel:supply({ "ResetLoggerKeys", false })
				elseif choiceClicked == 5 then
					LuaCraftSettingsUpdater("renderdistanceSetting")
					Renderdistancegetresetted = true
				elseif choiceClicked == 6 then
					if Gamestate == GamestatePlayingGameSettings then
						Gamestate = GamestateKeybindingPlayingGameSettings
						_MainMenuSettings.selection = 0
					elseif Gamestate == GamestateMainMenuSettings then
						Gamestate = GamestateKeybindingMainSettings
						_MainMenuSettings.selection = 0
					end
					_MainMenuSettings.selection = 0
				elseif choiceClicked == 7 then
					if Gamestate == GamestatePlayingGameSettings then
						Gamestate = GamestatePlayingGame
						_MainMenuSettings.selection = 0
					elseif Gamestate == GamestateMainMenuSettings then
						Gamestate = GamestateMainMenu
						_MainMenuSettings.selection = 0
					end
				end
			end
		end
	elseif Gamestate == GamestateWorldCreationMenu then
		if b == 1 then
			local choiceClicked = math.floor((y - _WorldCreationMenu.y) / Font15:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_WorldCreationMenu.choice then
				_WorldCreationMenu.selection = choiceClicked
				if choiceClicked == 1 then
					Gamestate = GamestatePlayingGame
					love.mouse.setRelativeMode(true)
					GenerateWorld()
				elseif choiceClicked == 2 then
					Gamestate = GamestateMainMenu
					_WorldCreationMenu.selection = 0
				end
			end
		end
	elseif Gamestate == GamestateGamePausing then
		if b == 1 then
			local choiceClicked = math.floor((y - _GamePlayingPauseMenu.y) / Font25:getHeight("X"))
			if choiceClicked >= 1 and choiceClicked <= #_GamePlayingPauseMenu.choice then
				_GamePlayingPauseMenu.selection = choiceClicked
				if choiceClicked == 1 then
					love.mouse.setRelativeMode(true)
					Gamestate = GamestatePlayingGame
				elseif choiceClicked == 2 then
					Gamestate = GamestatePlayingGameSettings
				elseif choiceClicked == 3 then
					--TODO here add chunk saving system before going to MainMenu and during gameplay
					for chunk in pairs(ChunkSet) do
						for _, chunkSlice in ipairs(chunk.slices) do
							chunkSlice.alreadyrendered = false
							chunkSlice.model = nil
						end
					end

					ChunkSet = {}
					ChunkHashTable = {}
					CaveList = {}
					ThePlayer.IsPlayerHasSpawned = false
					Gamestate = GamestateMainMenu
				end
			end
		end
	elseif Gamestate == GamestatePlayingGame then
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
		elseif
			pos
			and pos.x
			and pos.z
			and pos.y >= WorldHeight
			and ThePlayer.cursorpos
			and ThePlayer.cursorHit == true
		then
			HudMessage = "you cannot place blocks at Y = " .. WorldHeight .. " or more"
			HudTimeLeft = 3
		end
		_JPROFILER.pop("MouseLogicOnPlay")
		_JPROFILER.pop("frame")
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
	elseif Gamestate == GamestatePlayingGame then
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
