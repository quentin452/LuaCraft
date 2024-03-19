--mouseandkeybindlogic.lua
function GamestateKeybindingPlayingGameSettingsMouseAndKeybindLogic(x, y, b)
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
end

--!draw.lua
function GamestateKeybindingPlayingGameSettingsDrawGame()
	if Gamestate == Gamestate == GamestateKeybindingPlayingGameSettings then
		_JPROFILER.push("drawMenuSettings")
		DrawKeybindingSettings()
		_JPROFILER.pop("drawMenuSettings")
	end
end
