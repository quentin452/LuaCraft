function KeyPressed(k)
	if k == "f11" then
		LuaCraftSettingsUpdater("toggleFullScreen")
	end
	LuaCraftCurrentGameState:keypressed(k)
	if ConfiguringMovementKey_KeyPressed then
		if k == "escape" then
			ConfiguringMovementKey_KeyPressed = false
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
						ConfiguringMovementKey_KeyPressed = false
					end
				end
			end
		end
	end
end
